+++
title = "Concurrency versus Parallelism"
slug = "concurrency-versus-parallelism"
date = "2015-10-17"
+++

> In a universe where countless events unfold simultaneously and we cannot even begin to comprehend their sheer number, everything is in a state of constant change. This relentless flux often leaves us without a clear direction or the ability to foresee what lies ahead, making it challenging to maintain a steady flow or exercise foresight amidst the chaos.

Imagine standing in line to place an order for a meal. As you wait your turn, the cashier takes orders while the person ahead of you steps aside to make a call. Meanwhile, a new order swiftly arrives in the kitchen. Nearby, another attendant is busy serving a previous order, and you find yourself glancing at your powerful four-core smartphone, pondering which movies are playing at the theaters while listening to your favorite band. 

> This bustling scene is a condensed illustration of the dynamic environment surrounding us. Over the years, software development has evolved, creating advanced tools, languages, and methodologies to manage our complex “universe” of events.

Modern programs are designed to operate asynchronously, handling multiple requests simultaneously by processing previous tasks while calculating outputs for new ones at incredible speeds. This eliminates the need for sequential queues, allowing for intelligently divided tasks and multiple queues that efficiently manage numerous jobs concurrently.

## Concurrency

Anyone who has ever used a computer with only a single processor or core may have experienced the illusion of concurrency without even realizing it. Tasks such as receiving keyboard input, sending video output, playing music (perhaps Pink Floyd), receiving network data, and displaying new emails all seem to happen simultaneously. In reality, a single-core processor handles these operations sequentially, executing small, efficient tasks one at a time, each within microseconds (millionths of a second). This rapid task switching creates the perception of parallelism. However, a program not designed to operate concurrently will never perform satisfactorily on such systems. 

Similarly, programs that are not built to leverage parallelism cannot effectively utilize multiple processors or cores. Ultimately, hardware alone cannot compensate for software that does not take advantage of concurrency and parallelism.

## Parallelism

In the previous example, when I mentioned “everything happening at the same time,” I clarified that tasks weren’t truly simultaneous but were executed incredibly quickly in succession. 

To achieve true parallelism, where multiple tasks occur simultaneously, we require more than one processor or a single processor with multiple cores. This hardware allows two or more tasks to run at the same time. However, attaining parallelism also necessitates well-planned concurrency within the software; tasks must be designed to avoid conflicts, locks, or indefinite waits. 

When we discuss concurrency, our focus is on the software framework that manages multiple tasks efficiently. In contrast, parallelism emphasizes how these frameworks are executed across multiple processors or cores, leveraging the hardware to perform tasks simultaneously. 

Effective parallelism relies on both robust concurrent design and the appropriate hardware to ensure that multiple processes can run in tandem without interference.

## Concurrency and parallelism together

Now that we have a clear understanding of the necessary concepts, we can proceed to the final component. To effectively integrate concurrency and parallelism, we need to establish a communication structure that is both protected and scalable.

Achieving concurrency involves utilizing multiple routines within our program, which can be referred to as threads or simply routines. With parallelism, we distribute tasks across multiple processors or cores, but the crucial final element is the communication mechanism—the tunnel or channel that connects these routines. Without effective communication, having multiple routines serves no purpose. 

This communication must be synchronized to ensure that data does not arrive out of order or cause one task to block another. A synchronized mechanism is essential to allow all jobs to execute smoothly without one operation interfering with another, thereby enabling efficient and harmonious task management.

## Final considerations

Certainly, this is a complex subject that encompasses a significant amount of theory, often covered in dedicated courses within Computer Science programs, such as Operating Systems or Multiprocessed Systems. 

I hope this brief article has effectively illustrated and clarified the key concepts. In the next section, I will provide a more practical example, demonstrating how to implement concurrency and parallelism using Go programming.

## Sources
* Rob Pike, one of the creators of Go on his “Concurrency Is Not Parallelism” talk [https://www.youtube.com/watch?v=cN_DpYBzKso](https://www.youtube.com/watch?v=cN_DpYBzKso)
* The paper that influenced a generation [https://en.wikipedia.org/wiki/Communicating_sequential_processes](https://en.wikipedia.org/wiki/Communicating_sequential_processes)
* Golang Book [https://www.golang-book.com/books/intro/10](https://www.golang-book.com/books/intro/10)