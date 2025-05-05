### Go Concurrent Pipeline

# Description
This Go program implements a 3 stage concurrent pipeline using goroutines and buffered channels to coordinate communication. The pipeline includes:

- Stage 1 (Producers): Two goroutines generate numbers: one for odd numbers (1 to 29) and one for even numbers (2 to 30).
- Stage 2 (Processors): Two goroutines square the incoming numbers.
- Stage 3 (Final Filter): One goroutine prints only the squared values that are strictly increasing.

Buffered channels are used between each stage to safely pass data without shared memory, and sync.WaitGroup is used to coordinate the completion of all goroutines.

### What argument can you give that there will be no deadlock among these processes?
There shouldn’t be any deadlocks in this pipeline for a few reasons:
- Buffered channels: Both inCh and outCh have a buffer size of 5, which allows for temporary storage of data and prevents goroutines from immediately blocking when sending or receiving.
- Clear synchronization: sync.WaitGroup ensures that all goroutines are properly tracked and allowed to finish their work before the program exits.
- No circular dependencies: Each stage of the pipeline only depends on the previous one and not on itself or any future stage. For example, producers send to inCh, which is only read by the processors, and so on.
- Proper closure: Once producers are done, inCh is closed, which lets processors finish and close outCh, which then allows the final filter to exit. This design ensures that all goroutines terminate naturally without being left hanging.

So overall, data flows in one direction, channels are buffered, and all goroutines exit cleanly, meaning there's no risk of deadlock.

### How would we handle this situation in Elixir, where the mailbox semantics in actors mean that our "channel" is always attached to a single process? How do we have 2 producers creating and distributing values to 2 consumers?
In Go, channels are first class shared data structures, so fan-out (one producer, many consumers) and fan in (many producers, one consumer) are straightforward. But in Elixir, each process has its own mailbox, which acts like a private message queue.

To mimic fan in and fan out in Elixir, you'd need to introduce an intermediary process, like a router or hub. The two producer processes would send messages to this central dispatcher, which would then be responsible for forwarding the messages to the consumers. This lets multiple producers "fan-in" to one place, and then that dispatcher can "fan-out" to multiple consumers.

One would likely want some logic in the dispatcher to manage load balancing—maybe alternating which consumer gets a message or checking which one is available. This adds more complexity compared to Go, but it's a common pattern in Elixir thanks to its actor model.
