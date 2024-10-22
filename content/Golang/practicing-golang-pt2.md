+++
title = "Practicing Golang (Part 2)"
slug = "practicing-golang-pt2"
date = "2015-10-13"
+++

## Channels and Routines

The time has come to talk about one of the main features of the Go language.

Undoubtedly one of the most exciting things about language is that competition is in the “blood”; it is in the core of the language, it does not need an auxiliary library, not even “workarounds” or “macgyverisms”.

Furthermore, the responsible for this are the go call, the channel type, and the routine.

The go keyword will cause a function linked to the main thread to become independent, ie a routine and keep running until it ends and the channel type is responsible for facilitating communication with background routines, the channel type is synchronized, and when it has a value entered (think like a pipe), it only receives another value if the first one is read (if the pipe is empty), this attitude prevents the functions connected by the channel from being unsynchronized . There are also buffered channels, but this is homework (more information at https://tour.golang.org/concurrency/1).

```go
func pool() chan string {
	ch := make(chan string)
	go func() {
		haveResponse := false
		requestJSON := func() {
			if res, err := checker(); err == nil {
				if jsonRes := parseJSON(res); jsonRes != "" {
					haveResponse = true
					ch <- jsonRes
				}
			}
		}

		for {
			requestJSON()
			if haveResponse {
				break
			} else {
				log.Println("No result try again ...")
			}
		}

		c := time.Tick(5 * time.Minute)
		for now := range c {
			log.Println("Updated at %v", now)
			requestJSON()
		}
	}()
	return ch
}
```

When executed, the pool function going to create a string channel that is used to communicate with the routine that creates ion line 3, see that the keyword go is present, causing the anonymous function to be in the background. In line 5, we are creating a function and assigning a variable (anonymous function), it requests by calling the functions checker and parseJSON for on line 9 that going to insert in the communication channel the result of USD. The loop on line 14 ends when we have a value in the channel, because sometimes the request made to Yahoo! doesn’t return the value in USD, so we need to make sure it has value right from the start.

On line 24, we have an infinite loop that executes every 5 minutes with the help of the time. Tick function responsible for pinging the loop so that it executes with the necessary pause

## Main function

Like its C language predecessor, the main function is also called main.

```go
func main() {
	// Get the first value
	checkerpool := pool()
	latestResult := <-checkerpool

	// To deploy at heroku :D
	env := os.Getenv("GO_ENV")
	host := "127.0.0.1"
	port := 9000
	//token := ""

	if env == "PRODUCTION" {
		host = ""
		port, _ = strconv.Atoi(os.Getenv("PORT"))
		//token = os.Getenv("TOKEN")
	}

	address := fmt.Sprintf("%s:%d", host, port)
	log.Println("Ready to serve at", address)

	http.HandleFunc("/", func(rw http.ResponseWriter, req *http.Request) {
		select {
		case latestResult := <-checkerpool:
			log.Println("Get result", latestResult)
		default:
			log.Println("Get cache value")
		}

		_, err := rw.Write([]byte(latestResult))

		if err != nil {
			log.Println(err)
		}
	})

	if err := http.ListenAndServe(address, nil); err != nil {
		log.Fatal("Failed to serve to address", address, err)
	}
}
```
So finally, we can finish (or start, depends on the point of view). On line 3 should create a pool using the pool function that returns the channel, and on line 4 the value contained in the channel should be removed and inserted in the latestResult variable (which, as the name suggests, should keep the last result).

Up to line 19, initialization routines will be performed, such as setting variables and checking the environment, and if it is necessary to change the HTTP port (necessary when using Heroku). On line 21 a handler is created for the route “/” and assigned to a function, which should receive the HTTP request, at this moment on line 22 comes the keyword select that tests: if in case a value was successfully removed from the channel follows with execution or default value: if no value has been removed, ie, if the channel is empty you can also follow successfully. Finally, the latestResult value is written to the HTTP response; now the result it should return the value to the requesting user.