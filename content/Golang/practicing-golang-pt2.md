+++
title = "Practicing Golang (Part 2)"
slug = "practicing-golang-pt2"
date = "2015-10-13"
+++

## Channels and Routines

The time has come to discuss one of the main features of the Go language: concurrency. Undoubtedly, one of the most exciting aspects of Go is that concurrency is ingrained in the language’s core. It does not require auxiliary libraries, workarounds, or makeshift solutions. 

The key components responsible for Go’s concurrency model are the go keyword, channels, and goroutines. The go keyword initiates a function as a goroutine, allowing it to run independently alongside the main thread until it completes. Channels facilitate communication between goroutines by providing a synchronized way to send and receive values. When a value is sent to a channel (similar to a pipe), it is only received if the channel is ready to accept it, ensuring synchronization and preventing race conditions between connected functions. 

Additionally, Go supports buffered channels, which allow for more flexible communication patterns by enabling channels to hold a specified number of values without immediate receipt. Understanding these concurrency mechanisms is essential for building efficient and scalable applications in Go. For more information, visit the Go Concurrency Tour.


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

When executed, the pool function creates a string channel used for communication with the goroutine initiated on line 3. The presence of the go keyword ensures that the anonymous function runs in the background. On line 5, we define and assign an anonymous function to a variable, which calls the checker and parseJSON functions on line 9 to insert the USD result into the communication channel. The loop on line 14 terminates once a value is received from the channel, addressing scenarios where a request to Yahoo! might not return a USD value by ensuring a value is present from the outset.

Furthermore, on line 24, an infinite loop is established to execute every five minutes, utilizing the time.Tick function to trigger the loop with the necessary pauses.


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

Finally, we reach the concluding steps of our implementation. On line 3, we create a pool using the pool function, which returns a channel. On line 4, the value from this channel is retrieved and stored in the latestResult variable, which, as its name suggests, holds the most recent result. Up to line 19, various initialization routines are performed, including setting variables, checking the environment, and, if necessary, changing the HTTP port (which is essential when deploying to platforms like Heroku). On line 21, a handler is created for the root route “/” and assigned to a function designed to handle HTTP requests. 

At this point, on line 22, the select statement is used to check if a value was successfully retrieved from the channel. If a value is present, the corresponding execution path is followed; otherwise, the default case is executed if the channel is empty. Finally, the latestResult value is written to the HTTP response, ensuring that the requesting user receives the most recent USD value.
