![Swift](https://github.com/stuedev/CombineTestbox/actions/workflows/swiftbuild.yml/badge.svg)

# What is **Combine Testbox**?

```swift
// declare expectations

let testbox = Testbox
{
    "sub" > receiveValue(1)
    "sub" > receiveCompletion(.finished)
}


// insert "probes" into combine chain

Just(1)
    .test(testbox, probe: "sub")
    .sink { _ in }
```

**Combine Testbox** is a framework dedicated to testing Apple Combine.
Its goal is to allow writing *automated tests* which **precisely describe the behaviour** of a Combine chain while aiming to offer a maximum of ergonomics to the author.

**Combine Testbox** is currently available as a Swift Package.

# Contents

- [Motivation](#motivation)
- [How does it work?](#how-does-it-work)
  - [1. Declaring expectations](#1-declaring-expectations)
  - [2. Setting up the Combine chain](#2-setting-up-the-combine-chain)
  - [3. Running the Combine chain](#3-running-the-combine-chain)
  - [4. Telling the Testbox to wait](#4-telling-the-testbox-to-wait)
  - [Run the test](#run-the-test)
- [Expectations](EXPECTATIONS.md)
- [Combine events](COMBINE_EVENTS.md)

# Motivation

So why would you want to use **Combine Testbox**? What is it for exactly?

Have you ever tried to write your own **custom Combine Publishers or Operators**? Implementing all the necessary protocols and piecing it all together? If so, you might have come across the question: **Does this thing really work the way it should?** Or even worse: You thought it's working, but at some point during development, it's not doing what you expected. At this point you might think: Wow, ok, i really need to test this properly!

I've had this experience as well. And, of course, the first instinct is to go write some **automated tests** to make sure that the code behaves the way you want. To make sure that you *control* the way it behaves. What this means, is that you control the **events**. There's so much happening in a typical *Combine chain*. Details you barely notice but which are important, like:

- *When does my operator subscribe to its upstream?*
- *When does it request demand from its upstream?*
- *Does my operator react correctly to incoming demand from its subscriber?*
- *Was a value filtered out somewhere?*

Wouldn't it be nice if we could just write some kind of **script** in which we define **every single event** that is happening during a specific test scenario? Events that happen not only at once place in the chain but in **multiple places**. Like:

- *What is happening between my operator and its downstream?*
- *What is happening between my operator and its upstream?*
- *What is happening right below the (top-most) original publisher (e.g. a Subject)?*
- *What does the final subscriber eventually receive from the chain?*

If we had a way to write such a **script**, we could test all these things and more, in a **single test**.

This is why **Combine Testbox** was created.

# How does it work?

Writing an automated test with **Combine Testbox** consists of **four parts**:

## 1. Declaring expectations

**Expectations** are declared by creating a **Testbox** instance.

```swift
let testbox = Testbox
{
    "upstream" > receiveValue(2)
    "sub" > receiveValue(4)
}
```

In this example we declare two expectations which require our two **probes** "upstream" and "sub" to each receive a specific value. This means that while the Combine chain is "running", the probes will "see" these values as they pass through the chain.

**Combine Testbox** is using the **Result Builder** feature from Swift to provide a **Domain Specific Language** (DSL) for declaring expectations, in a similar way as you are used from writing **SwiftUI** code. 

> **Note**<br>
> The features of the DSL are described in detail in the following chapters.

## 2. Setting up the Combine chain

Now, we need to **place our probes**. Probes can be placed anywhere in the Combine chain, as long as they are placed between the *Publisher* and the *Sink*.

```swift
let subject = PassthroughSubject<Int, Never>()

let chain =
    subject
        .test(testbox, probe: "upstream")
        .map { $0 * 2 }
        .test(testbox, probe: "sub")
```

Here, we have placed two probes:
* One **above** the *map* operator (**upstream**). We call it "upstream".
* One **below** the operator (**downstream**). We could call it "downstream", but we call it "sub" instead, because its what the *Subscriber* (our *Sink*) will "see".

## 3. Running the Combine chain

With the expectations and Combine chain set-up, we're ready to actually produce some **events**! In the following example, we first subscribe to the chain by connecting a *Sink* to it, and then send a *value* to the subject.

```swift
let sub = 
    chain
        .sink { _ in }
        
subject.send(2)
```

> **Note**<br>
> Subscribing to the chain produces a respective event as well (`.receiveSubscriber`), but we omitted it in our expectations for sake of simpliciy.

## 4. Telling the Testbox to "wait"

Finally, we need to run the **Testbox**.

```swift
testbox.wait(timeout: 1.0)
```

By doing so, the current queue is blocked until either
1. all expectations were fulfilled
2. an expectation raised a failure
3. the timeout was hit

> **Note**<br>
> This is basically the same thing that happens when you use the `wait(for:timeout:)` API from the *XCTest* framework in your automated tests.

## Run the test

Now we're ready to run our test! If everything is good - and all of our **expectations** are fulfilled - the test will succeed ✔️. If any of the expectations were not matched, the test will fail ✖️.

> **Note**<br>
> You dont need to *expect* (declare an expectation) every event that is produced for your probes. You can only expect those which you are interested in. If an event is not matched by an expectation and doesn't lead to a failure, it is simply discarded (ignored).<br>
> <br>
> There is one exception: If an event is tested in a *strict context*, it must be matched by some expectation or it will lead to a failure. (More on *strict contexts* [here](EXPECTATIONS.md#strict))

In case of a failure, the *diagnostics message* will be shown in the Xcode UI at the respective line of code where the related expectation was declared.
