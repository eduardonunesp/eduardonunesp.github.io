+++
title = "Practicing Golang (Part 1)"
slug = "practicing-golang-pt1"
date = "2015-10-13"
+++

On my previous article: Golang, a month later, I took a brief look at the programming language that was born inside Google and showed some points that I found exciting and others not so memorable.

So I decided to show in practice (according to my bars) how to build a simple service using HTTP and to send requests and a bit of concurrency (nothing too complicated).

The service in question is a consumer service that translates the USD currency to the BRL currency (Dollars to Real); so the user is going to send a request to the service, and it responds with the current dollar value of the last 5 minutes.

Why the last 5 minutes? That’s when the competition comes in because a routine is running that continually checking the dollar via HTTP request every 5 minutes (all at the same time).

This way, whenever a user request arrives at the service, it immediately returns the value it needs because it does not need to consult another service whenever a new request arrives, and all because it stores the last value in memory and concurrently.

No worries, the explanation is in a nonlinear way; I mean, not the way it is performed, but in the end, all explanations going to make sense (at least I hope).

## Initial structure

# To interpret JSON, we need to associate it with a structure; this is very common in language

Our structure or type struct must reflect the return of the service to be queried. Let’s look at a Yahoo! which converts USD to BRL and returns the requested values in JSON format.

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

The following structure is “reflecting” the JSON format that is expected and answered by the Yahoo! service.

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

Next, we should send a request for the service according to the following URL and code (I advise you to visit the Yahoo! documentation at https://developer.yahoo.com/yql/)

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

The checker function should return two parameters (remember I mentioned in the previous article about functions returning the error and a result). On line 5 we are making the request using the get function of package HTTP (belongs to the standard library), we test if there was any error (err! = Nil), then we going to read the contents on line 18 and return the result of the function on line 24.

What about the defer on line 11?; that is a routine designed to be executed only when the function terminates, so function with defer on line 11 is going to be executed to terminate the HTTP request; that is an excellent strategy for clearing any pending resources in the role.

## Interpreting JSON

The idea now is to get the string of the checker function and return what interests us, the value in USD, for this, should perform the following function:

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

When the parseJSON function receives the JSON text result on line 3, we going to create an object based on the requestResult structure and line 5 the json.Unmarshal function should be responsible for interpreting the value and associating it with the structure, so the importance of the structure “reflects” JSON format and returning only what matters, which is the USD value