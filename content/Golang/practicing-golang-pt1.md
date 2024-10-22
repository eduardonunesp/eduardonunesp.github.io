+++
title = "Practicing Golang (Part 1)"
slug = "practicing-golang-pt1"
date = "2015-10-13"
+++

In my previous article on Golang, I took a brief look at the programming language developed by Google, highlighting some features that I found exciting and others that were less memorable. 

Building on that foundation, I decided to demonstrate, in practice, how to create a simple HTTP service that handles requests and incorporates basic concurrency — nothing too complicated. The service I developed is a currency converter that translates USD to BRL (US Dollars to Brazilian Reais). 

When a user sends a request to the service, it responds with the current dollar value based on data from the last five minutes. Why the last five minutes? This approach involves a routine that continuously checks the dollar rate via HTTP requests every five minutes concurrently. 

Consequently, when a user request arrives, the service can immediately return the required value without needing to query an external service each time, as it stores the latest value in memory and manages it concurrently. 

Don’t worry if the explanation seems nonlinear; while the process may not follow this exact order, I hope that all the explanations will make sense in the end.

## Initial structure

# To interpret JSON, we need to associate it with a structure; this is very common in language

Our data structure, defined using a struct, must accurately represent the response returned by the service when queried. For example, consider a service similar to Yahoo Finance that converts USD to BRL and returns the requested values in JSON format. To handle this response effectively in Go, we need to design a struct that mirrors the JSON structure, ensuring seamless data parsing and manipulation.

The initial structure should be:

```go
type requestResult struct {
	Query struct {
		Count   int    `json:"count"`
		Created string `json:"created"`
		Lang    string `json:"lang"`
		Results string `json:"results"`
	} `json:"query"`
}
```

The following struct mirrors the JSON format returned by the Yahoo! service.

```json
{
  "query": {
    "count":1,
    "created":"2015–10–13T00:55:09Z",
    "lang":"en-US",
    "results":"3.7616 BRL"
  }
}
```

Next, we will send a request to the service using the following URL and code snippet. I recommend consulting the Yahoo! documentation at https://developer.yahoo.com/yql/ for more detailed information.

```go
const url = "http://query.yahooapis.com/v1/public/yql?..."

// Make the request and return the content of body
func checker() (string, error) {
	resp, err := http.Get(url)

	if err != nil {
		return "", err
	}

	defer func() {
		err := resp.Body.Close()
		if err != nil {
			log.Println("Error to close get request")
		}
	}()

	contents, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		return "", err
	}

	return string(contents), nil
}
```

The checker function is designed to return two parameters, aligning with the practice mentioned in the previous article where functions typically return both a result and an error. On line 5, we make an HTTP request using the Get function from the http package, which is part of Go’s standard library. 

We then check for any errors by evaluating if err != nil. If no error occurs, we proceed to read the response content on line 18 and ultimately return the function’s result on line 24. Regarding the defer statement on line 11, it is a routine intended to execute only when the function terminates. 

By deferring the closure of the HTTP request, we ensure that it is properly terminated, effectively managing any pending resources. This is an excellent strategy for resource cleanup, preventing potential leaks and ensuring that all resources are released appropriately once the function completes.

## Interpreting JSON

The next step is to extract the USD value from the string returned by the checker function. To achieve this, the parseJSON function takes the JSON text result received on line 3 and creates an object based on the requestResult struct. On line 5, the json.Unmarshal function is responsible for parsing the JSON data and mapping it to the requestResult structure. This underscores the importance of designing the struct to accurately reflect the JSON format, ensuring that only the relevant data—the USD value—is extracted and returned. By aligning the struct with the JSON response, we enable efficient and precise data handling, allowing our service to focus solely on the information that matters.


```go
func parseJSON(jsonResult string) string {
	log.Println("JSON REQUEST", jsonResult)
	result := new(requestResult)

	err := json.Unmarshal([]byte(jsonResult), result)

	if err != nil {
		log.Println(err)
	}

	log.Println(result)

	return result.Query.Results
}
```

When the parseJSON function receives the JSON text result on line 3, it creates an object based on the requestResult struct. On line 5, the json.Unmarshal function is responsible for parsing the JSON data and mapping it to the requestResult structure. This highlights the importance of designing the struct to accurately mirror the JSON format, ensuring that only the relevant data—the USD value—is extracted and returned. By aligning the struct with the JSON response, we facilitate efficient and precise data handling, allowing our service to focus solely on the information that matters.