# Expectations

**Combine Testbox** provides an extensive set of **expectations** which can be used to not only precisely describe the behaviour of a Combine chain, but also to make writing expectations easier and more readable, for example by grouping expectations and reusing sections of expectations.

In this chapter, we will look in detail at each of these expectations.

## Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Combine expectations](#combine-expectations)
- [Group](#group)
- [Section](#section)
- [Unordered](#unordered)
- [ForEach](#foreach)
- [Functions](#functions)
- [Custom events](#custom-events)
- [Not](#not)
- [Strict](#strict)
- [Ignore](#ignore)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Combine expectations

These are the most fundamental of expectations. Each Combine expectation directly describes one Combine event, like receiving a value.

The syntax of a Combine expectations is as follows:

```
probe > combine_event
```

Since Combine events occurr at specific places in the chain, we need to define the **probe**. Then, after a `>` sign follows the **Combine event type**.

Here is a quick list of examples:

```swift
"sub" > receiveValue(1)
"sub" > receiveCompletion(.finished)
"sub" > requestDemand(.unlimited)
"sub" > receiveSubscription()
```

For a complete list of *Combine event types* see [here](COMBINE_EVENTS.md).

## Group

*Group* is the first **nesting expectation** we'll learn about. "Nesting" means that the expectation "hosts" a set of *child expectations*.

This expectation actually doesn't do much except for being a *structural tool* for grouping a set of expectations together, for better readability.

```swift
group
{
    "sub" > receiveValue(1)
    "sub" > receiveCompletion(.finished)
}
```

Additionally, you can give the group a **title**.

```swift
group("receiving values")
{
    ...
}
```

## Section

*Section* is similar to *Group* in the way that it is also a *structural tool*. However, *Section* is used for structuring the *test code* as well.

```swift
testbox.section("send value (1)")
{
    subject.send(1)
}
```

We "open" a section by using the `section` method on our *Testbox*. Inside the closure, we now perform the actions we want to be associated with the section.

A matching expectation declaration would look like this:

```swift
section("send value (1)")
{
    "upstream" > receiveValue(1)
    "sub" > receiveValue(1)
}
```

This example assumes that we have set-up two probes, "upstream" and "sub". And it illustrates how a single action, like sending a value to the *Subject*, can lead to a - potentially complex - chain of events.

> **Note**<br>
> All events which are direct consequences of the actions inside the `testbox.section` closure will be associated to the section, and their respective expectations must be declared inside the section.

## Unordered

In some cases, the *order of events* is not deterministic. One example is the **Multicast** operator in Combine.

```swift
let chain =
    subject
        .test(testbox, probe: "upstream")
        .multicast(subject: PassthroughSubject<Int, Never>())
        .autoconnect()
```

Now, we're connecting two *Subscribers* (Sinks) to the operator, and then we're sending a value to the subject at the top of the chain.

```swift
// setup subscribers

let sub1 =
    chain
        .test(testbox, probe: "sub1")
        .sink { _ in }
        
let sub2 =
    chain
        .test(testbox, probe: "sub2")
        .sink { _ in }
        

// send value

subject.send(1)
```

The value we just sent into the chain now passes through the **Multicast** operator and is then sent into two separate sub-chains, each leading to one of the subscribers. So, we could declare our expectations like this:

```swift
"upstream" > receiveValue(1)

"sub1" > receiveValue(1)
"sub2" > receiveValue(1)
```

But, we're not guaranteed that "sub1" will always receive its value before "sub2" does! This has to do with **Multicast** and its "inner workings". The order is not deterministic.

This, of course, is a little bit awkward, because we are unable to write a test that will **always** work.

To solve this problem, the *Unordered* expectation exists. This is how the modified expectation declaration from above would look like:

```swift
"upstream" > receiveValue(1)

unordered
{
    "sub1" > receiveValue(1)
    "sub2" > receiveValue(1)
}
```

## ForEach

Sometimes, you will run into the issue of having to write redundant *expectation code*, for example when there are multiple values being sent, but the pattern of expectations is the same in all cases.

One way of avoiding redundancy is *ForEach*. It simply lets you iterate over an **array** whose **elements** can be used inside a closure. Consider the following test code:

```swift
subject.send(1)
subject.send(2)
subject.send(3)
subject.send(completion: .finished)
```

The following declaration will match these events using *ForEach*:

```swift
forEach([1,2,3])
{
    value in
    
    "upstream" > receiveValue(value)
    "sub" > receiveValue(value)
}

"upstream" > receiveCompletion(.finished)
"sub" > receiveCompletion(.finished)
```

Additionally, you can give the *ForEach* a **title**, which can be used to identify a specific *ForEach* expectation in the *stack* in the *diagnostics message*.

```swift
forEach("subject values", [1,2,3])
{
    ...
}
```

## Functions

Of course, the best way to avoid redundant code is **functions**. Fortunately, in **Combine Testbox** we have that as well!

```swift
// define the function

func receive(value: Int) -> Function
{
    Function("receive")
    {
        "upstream" > receiveValue(value)
        "sub" > receiveValue(value)
    }
}

// call the function

let testbox = Testbox
{
    call(receive(1), "first value")
    call(receive(2), "second value")
    call(receive(3), "third value")
}

```

As we can see, there are two parts to using **functions**:

### 1. Defining the function

We need to create a **Function** instance, which is basically a *wrapper* for a set of expectations. A Function must also have a **name**, so it can be identified in the *stack* in the *diagnostics message*.

The Function instance then needs to be returned from a *closure*, which can, of course, also be a function in Swift. The idea is that a closure/function can be customized with whichever parameters you need to be used inside the Function's *expectation code*.

### 2. Calling the function

In your *expectation code*, you then simply call the function we defined above using the `call` expectation. It expects two parameters: 
1. The Function instance we get from calling the closure/function
2. A *String* describing the **context** of the call. This context is used to identify the specific call instance of the Function in the *stack* in the *diagnostics message*.

### Limitations

Due to limitations of *Result Builders* in Swift, you cannot put a function declaration inside the *expectation code*. But you can instead use a closure declaration, like this:

```swift
let testbox = Testbox
{
    let receive: (Int) -> Function =
    {
        value in
        
        Function("receive")
        {
            // ...
        }
    }
    
    // ...
    
    call(receive(1), "first value")
}
```

## Custom events

Sometimes, you might want to create your own events and use them as something like a *marker* in your *expectation code*. You can then, for example, make the assumption that all expected events **after** the marker must be attributed to the *test code* you executed **after** sending the *custom event*.

```swift
// expectations

let testbox = Testbox
{
    "sub" > receiveSubscriber()

    custom("connect")   // our marker

    "upstream" > receiveSubscriber()  // Multicast subscribes to its upstream only after it was connected
}

// test code

let multicast =
    subject
        .test(testbox, probe: "upstream")
        .multicast(subject: PassthroughSubject<Int, Never>())

let sub =
    multicast
        .test(testbox, probe: "sub")
        .sink { _ in }      // here we subscribe to the Multicast

testbox.reportCustomEvent("connect")    // here we send our marker event

op.connect()    // here we connect the Multicast
```

In the above example, we can use the *custom event* to find out, that **Multicast** does not subscribe to its *upstream* and *request demand* to it **before** we manually *connect* it using the `connect` method. Without the *custom event*, we could  believe that it does subscribe immediately after it itself was subscribed to, like most *Combine operator*.

> **Note**<br>
> The `receiveSubscriber()` expectation describes that the *link* in the *Combine chain* **below** the associated probe issued a *subscribe* event to its upstream. More on *Combine events* [here](COMBINE_EVENTS.md).

> **Note**<br>
> An alternative way to *mark* specific *test code* in your *expectation code* is to use [sections](#section).

## Not

*Not* allows you to **invert** expectations. It exists mostly for *semantic* purposes.

```swift
// expectations

let testbox =
    Testbox
    {
        "sub" > receiveValue(1)
        
        not("sub" > receiveValue(2))    // 2 is an odd number and not received by "sub"
        
        "sub" > receiveValue(3)
    }

// test code

let sub =
    subject
        .filter { $0 % 2 == 1}  // only even numbers
        .test(testbox, probe: "sub")
        .sink { _ in }

subject.send(1)
subject.send(2)
subject.send(3)
```

Of course, in the example abobe, you might as well just *skip* the second expectation instead of inverting it, right? The test would still work basically in the same way. But you can use *inversion* as a **semantic tool** to *explicitely state* what is supposed to **not happen**. In the example, it could be significant to state that value (2) is blocked by the *Filter*.

Since *Not* is a *nesting expectation*, it can "host" multiple *child expectations*:

```swift
not
{
    "sub1" > receiveValue(2)
    "sub2" > receiveValue(2)
    "sub3" > receiveValue(2)
}
```

> **Note**<br>
> The *Not expectation* will fail if **any of the nested expectations were fulfilled**.

## Strict

This expectation needs special attention as a crucial piece when writing tests using **Combine Testbox** as it allows you to really "pin down" whats happening inside your Combine chain and guarantee that you're not missing any events in your *expectation code*.

With *Strict* you can define a **set of Combine Event types** which should be **treated strictly** in your expectation code. Defining *strict Combine Event types* will **raise a failure** in the following cases:

### 1. Mismatching Events

```swift
// expectations

{
    strict(.receiveValue)
    {
        "sub" > receiveValue(1)
        "sub" > receiveValue(2)     // event (value (3)) mismatches the expectation (value (2))
    }
}

// test code

subject.send(1)
subject.send(3)     // we send value (3) instead of (2)
```

In this example, we're sending two values which are picked up by our probe "sub". We declare expectations for both of them, expecting the values to be (1) and (2) respectively. Now, because we are in a **strict context** and have defined the **Combine event type** *receiveValue* as *strict*, we expect that - on the second expectation - **the next *receiveValue* event on the "sub" probe** must carry the **value (2)**.

But what actually happens is that we are receiving the **value (3)** instead. Since we're strict about this, however, a ***mismatching* failure** is raised and the test fails.

### 2. Unexpected Events

```swift
// expectations

{
    strict(.receiveValue)
    {
        "sub" > receiveValue(1)

        // value (2) is picked up by "sub" probe, but there is no expectation for it
    }
}

// test code

subject.send(1)
subject.send(2)     // value (2) is not expected
```

Here, we're sending two values (1) and (2), but only the first value is *expected*, i.e. declared in our *expectation code*. To explain what is happening here, we need to be precise:

The *Strict* expectation is the last expectation in our declaration, which means, that the *strict context* will be *active* until the end, so that all remaining incoming events will be handled inside the *Strict*. Now, when value (2) is picked up, it is **treated strictly**. But since we are not *expecting* it, an ***unexpected* failure** is raised.

### "Exiting" Strict

As we have seen in the previous example, *Strict* will handle **all remaining incoming events**. But this is only the case if it is the last expectation in the declaration. We can "exit" the *strict context* by appending more expectations below:

```swift
// expectations

{
    strict(.receiveValue)
    {
        "sub" > receiveValue(1)
    }

    "sub" > receiveValue(2)
    "sub" > receiveValue(3)     // incoming value (4) does not match here
}

// test code

subject.send(1)
subject.send(2)
subject.send(4)
```

This is what happens in this example:

* Value (1) is matched by the expectation inside the *Strict*
* Then, value (2) arrives, but there is no expectation for it inside the *Strict*. But there is a **follow-up** expectation next below the *Strict* which can match the value. This will lead to both the *Strict* and its *follow-up* being **fulfilled**. Now, the next expectation "in line" is the *receiveValue(3)*.
* Finally, value (4) is sent and is **tested** in the *current* expectation, which is *receiveValue(3)*. Here, it obviously mismatches, but it does not lead to a **failure**, since we have "exited" the *strict context* before.

### API

*Strict* expects either a **single event type**

```swift
strict(.receiveValue)
```

or a **set of event types**.

```swift
strict([.receiveSubscriber, .receiveValue, .receiveCompletion])
```

Since the *argument type* is an **OptionSet**, you can also perform *Set operations* on it:

```swift
strict(.all.subtracting([.receiveSubscriber, .receiveSubscription]))
```

## Ignore

There may be cases where you have committed to being *strict* about declaring expectations for all events of a specific type (or multiple specific types, or all types), but then you realize that you are now forced to write more expectation code than you deem necessary for the general understanding of the test.

```swift
// expectations

strict(.all)
{
    // "sub" > receiveSubscriber()
    // "sub" > receiveSubscription()
    // "sub" > requestDemand(.unlimited)

    ignore()
    
    custom("connect")
    
    "upstream" > receiveSubscriber()
    "upstream" > receiveSubscription()
    "upstream" > requestDemand(.unlimited)
    
    
}

// test code

let multicast =
    subject
        .test(testbox, probe: "upstream")
        .multicast(subject: PassthroughSubject<Int, Never>())

let sub =
    multicast
        .test(testbox, probe: "sub")
        .sink { _ in }

testbox.reportCustomEvent("connect")

let con = multicast.connect()
```

In this example we look at the *subscription behaviour* of the **Multicast** operator again. As we know, *Multicast* is a *ConnectablePublisher*, which means, that it will only subscribe to its upstream **after it was *connected***, either manually or automatically. The test case wants to illustrate this behaviour.

First, we open a *strict(.all)* context, because we're interested in *Combine events* dealing with *subscribing* and *requesting demand* (`.all` is shorter than listing each individual type). Now, when we create our *subscriber* "sub" and chain it to the *Multicast*, *Combine events* will be produced and picked up in the "sub" probe (these are the ones in comments at the top of the declaration). The *strict* context requires us to add them to the *expectation code*, otherwise it would raise a **failure**.

But we are actually not really interested in *modelling* the *subscribe behaviour* of our *subscriber* for the purpose of this test case. So we would be happy with omitting it. But, since we decided to be *strict* about these events in general, we have to. This is where **Ignore** comes into play.

**Ignore** can be placed anywhere and it will "consume" all incoming events. That is **until its *follow-up* expectation is *fulfilled***. In the example above, *Ignore* will "eat up" all the events related to the *subscriber subscribing*. But then, when our *custom event* arrives and is matched in the respective expectation right below the *Ignore*, the job of *Ignore* is done and it is *fulfilled*. We then continue in the *expectation code* with the rest of the expectations. By doing so, we match the events being produced by the *subscription behaviour* of the *Upstream* and the test succeeds.

