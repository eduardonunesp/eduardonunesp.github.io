+++
title = "Golang One Month Later (Part 1)"
slug = "golang-one-month-later-pt1"
date = "2015-10-09"
+++

{{ image(path="images/gophers1.png") }}

Maybe it’s been more than a month that I’m studying Go http://www.golangbr.org/; however this is not the case, the important thing is that I want to share a little of what happened during this period — starting with the fact that I had not been studying a new language for some time (in fact Go is really new, it was released to the public on March 2012, when I was “immersed” in Python and then Node.JS).

## The Way Go Creates Its Environment

In Python, we often use virtualenv to create a package environment that doesn’t mix with the global environment; in Node.JS, NPM makes life even more comfortable to create a dependency environment in the project directory itself. Go has an approach that I found strange at first, but once I got used to making sense.

The idea is to create a root directory for the environment, which contains dependencies and sources projects on this path, as well as the compiled binaries in Go.

It requires setting two GOPATH environment variables, which is the primary path for Go projects, not just your projects, but in reality, any project you download using the go get command uses this path. The second required path is $ GOPATH / bin, which can be added to your main PATH.

```
.
├── bin
│ ├── benchcmp
│ ├── consul
│ └── deadcode
├── pkg
│ ├── darwin_amd64
│ ├── 9fans.net
│ ├── github.com
│ ├── golang.org
│ ├── gopkg.in
│ ├── honnef.co
│ └── sourcegraph.com
└── src
  ├── 9fans.net
  │ └── go
  └── github.com
    ├── eduardonunesp
    ├── golang
    ├── gordonklaus
    ├── gorilla
    ├── hashicorp
    └── heroku
```

## Where are my sources and binaries in Go?

{{ image(path="images/gopher_run.png") }}

### Packages, repositories, and binaries are all “connected”
The next thing I was surprised about was the package system, which concerns how you organize your projects and how you use third party projects and binaries.

Earlier I said that there is a path to sources? Then I realized that even the path to my Github repository was related to the code path as a local package. Note that the path “src / github.com / eduardonunesp” is the user path in Github and the project for example: “src/github.com/eduardonunesp/sslb” is the path where the project in Go should be used when you download this project using the command “go get github.com/eduardonunesp/sslb”. It will automatically create in GOPATH the src directory and the bin directory, also the code and binary ready to use!

Even when you are coding in go you will need to refer to third party projects as the full path for example:

```go
package routes
import (
	"log"
	"strconv"
	"github.com/eduardonunesp/sslb/cli"
	"github.com/gorilla/mux"
)
```


## Is there an error? No, now there is an error? Now it has? Not? then follow

{{ image(path="images/gopher_fix.png")}}

### Go doesn’t want you to miss or forget something; it bugs you with until you learn it.

Extremely “complain” about this compiler, the metalinter doesn’t even talk about it, Go protect you from yourself all the time. Annoying yes, but it’s your friend and is always warning you that there are unused variables, no return functions, useless imports, and even when deadlocks killed your ordinary program.

Since Go functions can return more than two variables, it is pretty common to return an error type and a result, so you are continually doing error checks one after the other in heaps. Go even has an exception type called panic, but it’s not recommended overuse it.

The code formatting pattern is a rule that you have a program to format your code (it comes bundled and is called go format). To be clear: metalinter is a collection of various static checks. When I pass my code of even sadness, I have to complain that the code is too big, or that my keyboard is dirty, jokes aside, when you follow this linter, the code is standard Go Master.