+++
title = "Real Time Volume-Weighted Average Price"
slug = "rtvwap"
date = "2023-10-13"
+++

Today I'm going to talk about an analysis indicator know as Volume-Weighted Average Price. In the fast-paced world of financial markets, traders are constantly on the lookout for tools and strategies to help them make informed decisions.

One such tool that has gained significant popularity over the years is the Volume-Weighted Average Price (VWAP). VWAP is more than just an indicator; it's a powerful concept that traders use to gain insights into market dynamics, execute orders effectively, and improve their trading strategies. In this blog post, we will delve into what VWAP is, how it works and create our own in Go.

## First what is VWAP?

Volume-Weighted Average Price (VWAP) is a trading indicator that provides a benchmark price for a particular security over a given time period, typically a trading day. Unlike traditional moving averages, VWAP takes into account both the price and the volume of trades. In essence, VWAP calculates the average price at which a security has traded throughout the day, weighted by the volume of those trades. It's calculated using the following formula:

```
VWAP = (Σ(Price * Volume)) / ΣVolume
```

## Creating the trading structures

So first lets create the structures that we will use to represent the trades and the VWAP result. We will also create an interface that all trade providers must implement. This will allow us to create a VWAP calculator that can be used with any trade provider.

```go
// TradeChannel is the channel is used to receive trades from the provider
type TradeChannel chan Trade

// TradePair is the representation of the trading pair left and right pairs
// For instance ETH-USD, BTC-USD, USD-ETH
type TradePair struct {
	From string
	To   string
}

// Trade represents a trade that matched/closed on the provider
type Trade struct {
	TradePair TradePair
	Price     *big.Float
	Quantity  *big.Float
}

// VWAPResult serves as a container for the result of a VWAP calculation
type VWAPResult struct {
	Pair      TradePair
	VWAPValue *big.Float
}


// TradeProvider is the core interface that all trade providers must implement
type TradeProvider interface {
	GetTradeChannel(pair TradePair) (TradeChannel, error)
}
```

## Creating the VWAP calculator

Now that we have the structures in place we can create the VWAP calculator. The calculator will take a trade provider and a trade pair and return a channel that will be used to receive the VWAP result.

```go
// We're going to omit the imports and other boilerplate code for brevity

// Calculate runs the VWAP calculation and send the resut to a chan of thep VWAP result
// The VWAP has the realtime calculations
func (vwap *VWAP) Calculate(vwapResultChan chan<- VWAPResult) {
	go func() {
	outloop:
		for {
			select {
			case <-vwap.ctx.Done():
				break outloop
			case trade, ok := <-vwap.tradeChan:
				if !ok {
					break outloop
				}
				vwap.tradeSamples.PushBack(trade)

				// Keep max of queue buffer size or 200 samples
				for vwap.tradeSamples.Len() > queueBufferSize {
					e := vwap.tradeSamples.Front()
					vwap.tradeSamples.Remove(e)
				}

				// PV = Σ(Price * Volume)
				sumPriceAndVolume := new(big.Float)
				for e := vwap.tradeSamples.Front(); e != nil; e = e.Next() {
					priceAndVolume := new(big.Float).Mul(e.Value.(Trade).Price, e.Value.(Trade).Quantity)
					sumPriceAndVolume = new(big.Float).Add(sumPriceAndVolume, priceAndVolume)
				}

				// SV = ΣVolume
				sumVolume := new(big.Float)
				for e := vwap.tradeSamples.Front(); e != nil; e = e.Next() {
					sumVolume = new(big.Float).Add(sumVolume, e.Value.(Trade).Quantity)
				}

				// VWP = PV / SV
				result := VWAPResult{
					Pair:      trade.TradePair,
					VWAPValue: new(big.Float).Quo(sumPriceAndVolume, sumVolume),
				}

				vwapResultChan <- result
			}
		}
	}()
}
```

## Getting the trades from the provider

Now that we have the VWAP calculator we need to get the trades from the provider. For this example we will use the [Coinbase Pro Websocket API](https://docs.cloud.coinbase.com/exchange/docs/websocket-overview) to get the trades in realtime. We will create a function that will get the trades from the provider and send them to the VWAP calculator.

```go
// We're going to omit the imports and other boilerplate code for brevity

// CreateTradeProvider will return the TradeProvider ready to use with a go channel ready to consume
func (c coinbaseProvider) GetTradeChannel(pair internals.TradePair) (internals.TradeChannel, error) {
	// Connect to the websocket API 
	wsConn, err := newCoinbaseWS()
	if err != nil {
		return nil, ErrFailedToConnect
	}

	// Subscribe to the match channel
	if err := subscribeToMatchChannel(wsConn, pair.String()); err != nil {
		return nil, ErrFailedToSubscribe
	}

	tradeChan := make(internals.TradeChannel)

	go func() {
		defer close(tradeChan)
		defer wsConn.Close()

		var errCounter int

	outerloop:
		for {
			select {
			case <-c.ctx.Done():
				break outerloop
			default:
				// Get the response from the websocket
				price, quantity, err := matchResponse(wsConn)
				if err != nil && errors.Is(err, errNonExpectedMessage) {
					continue
				} else if err != nil {
					if errCounter >= ErrCounterThreshold {
						break outerloop
					}
					continue
				}
				errCounter = 0

				// Only accept with price and quantity ok
				if price == nil && quantity == nil {
					continue
				}

				// New trade ready to push into go channel
				tradeChan <- internals.NewTrade(pair, price, quantity)
			}
		}
	}()

	return tradeChan, nil
}
```

## Putting it all together

Now that we have the VWAP calculator and the trade provider we can put it all together. We will create a main function that will create the VWAP calculator and the trade provider. Then we will run the VWAP calculator and print the results to the console.

```go
// We're going to omit the imports and other boilerplate code for brevity

func main() {
	ctx, cancel := context.WithCancel(context.Background())
	vwapResultChan := createResultChan()

	pair := internals.NewTradePair("BTC", "USD")
	provider := tradeproviders.NewCoinbaseProvider(ctx)

	tradeChan, err := provider.GetTradeChannel(pair)
	if err != nil {
		panic(err)
	}

	internals.NewVWAP(ctx, tradeChan).Calculate(vwapResultChan)

	for {
		select {
		case result := <-vwapResultChan:
			fmt.Printf("VWAP RESULT %s %f\n", result.Pair.String(), result.VWAPValue)
		case <-waitSIGINT():
			cancel()
			close(vwapResultChan)
			os.Exit(0)
		}
	}
}
```

## Conclusion

In this blog post we have created a VWAP calculator that can be used with any trade provider. We have also created a trade provider that uses the Coinbase Pro Websocket API to get the trades in realtime. We have put it all together and printed the results to the console. I hope you have enjoyed this blog post and learned something new.

This code can be found at my [GitHub://eduardonunesp/rtvwap](https://github.com/eduardonunesp/rtvwap)