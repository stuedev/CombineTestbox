# Combine Events

*Combine events* are the most fundamental concept in **Combine Testbox**. After all, those are what we want to test. So, let's take a deeper look at all the different types.

## Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Receiving values](#receiving-values)
- [Receiving completions](#receiving-completions)
- [Requesting demand](#requesting-demand)
- [Requesting synchronous demand](#requesting-synchronous-demand)
- [Receiving a subscriber](#receiving-a-subscriber)
- [Receiving a subscription](#receiving-a-subscription)
- [Cancellation](#cancellation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Receiving values

We start with the most important type. *Values* (alternatively called **Output** in *Combine*) represent the data that is flowing through our *Combine chain*.

A *receiveValue* event will always carry a specific *value*. We can create an expectation which will **test** for that specific value.

```swift
"sub" > receiveValue(1)
```

> **Note**<br>
> Values which are to be tested with this expectation must conform to `Equatable`.

However, sometimes, we do not really care for the specific value, but merely that *a* value was received at that point in the *expectation code*. For this case, we can use the **unspecific version** of the expectation above.

```swift
"sub" > receiveValue()
```

Now let's think about a case where our *values* are no longer primitives, like integers or strings, but complex objects. If we wanted to test if a **specific** object was received, we would have to create such an object and pass it to our expectation.

We can, however, make the job much simpler. Especially, if we're only interested in testing *specific individual properties* of that object.

```swift
struct MyObject
{
    let id: UUID

    let string: String
}

// ...

"sub" > receiveValueTest { ($0 as? MyObject)?.string == "test" }
```

In this example, we're dealing with a custom struct with two properties `id` and `string`. The `id` is a **UUID** and might be *randomly generated*, so we might not know its exact value when we're trying to test the object anyway. The `string` is the actual data that is relevant for our test. We want to make sure that the string has the value we expect. For the value of the `id` we do not really care.

So we are using the **test version** of the expectation here, which is called slightly differently: `receiveValueTest`. It accepts a (trailing) closure, in which the **actual value during test time** is exposed. The closure expects a *bool* as return value, which determines if the value matches our expectation or not. Inside the closure, we are free to perform all kinds of tests on the object. In the example, we make the expectation that the `string` property has the value "test".

## Receiving completions

In *Combine*, there are two possible outcomes for when a *publisher* completes:
* .finished
* .failure(Failure)

We can test these 2 different cases pretty much in the same way as we test *values*.

```swift
"sub" > receiveCompletion(.finished)

// or ...

"sub" > receiveCompletion(.failure(MyError()))
```

> **Note**<br>
> Error types tested this way must conform to `Equatable`.

If we're not interested in the specific outcome of the completion, we can use the **unspecific version**.

```swift
"sub" > receiveCompletion()
```

Error types, like we just saw when *receiving values*, can be complex objects as well, and so, testing them might be difficult. But we have a **test version** for *errors* too.

```swift
struct MyError
{
    let underlyingError: Error

    let reason: Reason
}

// ...

"sub" > receiveCompletionTestError { ($0 as? MyError)?.reason == .timeout }
```

In this example, our error type `MyError` carries an `underlyingError` which can be used for further debugging. But this thing is probably way too complex to test as well, so we decide to ignore it and focus only on the `reason` property. In this case the reason is `.timeout`.

> **Warning**<br>
> This version expects that the case of the completion is `.failure`, so that it has an *Error* to send to the closure. If the actual case of the completion during a test is `.finished`, this expectation will always fail.

## Requesting demand

*Demand* is a metric in *Combine* used to communicate how many *values* a *subscriber* is willing to accept from its *upstream*. Typically, before any value can flow inside the *Combine chain* - from link to link - *demand* has to be requested. Each link has to request a specific amount of *demand* to its respective *upstream*.

Of course, we can measure these *demand events* in our probes.

```swift
"sub" > requestDemand(.unlimited)
```

This expectation accepts a `Combine.Subscribers.Demand` value and fulfills if the specified value was successfully tested. There is also an **unspecific version**:

```swift
"sub" > requestDemand()
```

## Requesting synchronous demand

*Synchronous demand* is a special case of demand that is issued by a *subscriber* **directly after receiving a value** from its upstream.

> **Note**<br>
> For more information about the technical details check out [this source](https://developer.apple.com/documentation/combine/subscriber/receive(_:)).

Writing expectations for *synchronous demand* works similar to regular demand events.

```swift
"sub" > requestSynchronousDemand(.max(1))

// and

"sub" > requestSynchronousDemand()
```

## Receiving a subscriber

To establish a *connection* between two links in the *Combine chain*, a link *subscribes* to the link above itself in the chain, its *upstream*. When this happens, a respective *Combine event* is produced.

This event can be tested using the following expectations. First, the **specific version**:

```swift
"upstream" > receiveSubscriber("Map")
```

This expectation describes that our probe "upstream" has seen that the *Map* operator below the probe has *subscribed* to its *upstream* (which is, of course, our probe, but our probe will simply *forward* the subscribe event to its own *upstream*, i.e. the *actual, intended upstream* of the *Map* operator). The expectation carries the *description* of the *subscriber*, here "Map".

If we're not interested in how the subscriber is called or what it is, we can use the **unspecific version**.

```swift
"upstream" > receiveSubscriber()
```

## Receiving a subscription

A *subscription* object is what is returned from the *upstream* after a *subscriber* has *subscribed* to it. It is used as a means for the *subscriber* to communicate with the *upstream*, like *requesting demand*.

When a *subscription* is received by the *subscriber*, a *Combine event* is produced, and we can test it.

```swift
"sub" > receiveSubscription("Future")
```

Here, our *subscriber* has received a *subscription* object from its *upstream*, a *Future* publisher. The expectation carries the *description* of the *upstream*.

Of course, there's also an **unspecific version**:

```swift
"sub" > receiveSubscription()
```

## Cancellation

A *subscriber* can **cancel** its *subscription* to its *upstream* at any time. A good example for *cancellation* is the *First* operator.

```swift
// expectations

let testbox = Testbox
{
    "upstream" > receiveValue(1)
    "upstream" > cancel()
    "sub" > receiveValue(1)
}

// test code

let chain =
    [1,2,3].publisher
        .test(testbox, probe: "upstream")
        .first()
        .test(testbox, probe: "sub")
        .sink { _ in }
```

After *First* has received its first value, it cancels its *subscription* to its *upstream* (ultimately the *Array publisher*).

In this example, we expect the *cancel* event on the *upstream* probe right after it has received its first value, and even before the value is sent to the *subscriber*.
