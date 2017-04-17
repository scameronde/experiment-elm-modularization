# Modularization of Elm UIs

Elm works by passing messages and a model to the program as a result of an
external event (mouse, key, timer, result from REST call, ...). For each
message-model pair it gets back a view, a new model, some commands to execute and subscriptions. If you want to split your program into smaller parts, it is your job to pass those in- and outputs along your call chain.

The idea of this experiment is, that a clear, simple and concise structure will help with this.

## Dividing UIs into smaller parts

First, a building block of an UI should not be too small. I am not talking
widget level here (a phone number entry field is too small for a building block in this context).

Second, a building block should have it's own use-case: a list of conference rooms from which you can add to, choose from; or an address entry/manipulation form; things like this.

## The inner workings of those smaller parts

Each part should be able to work on it's own.

- What it needs to initialize itself should be passed to it's `init` function.
- If a part should be able to receive external information, these should come as messages passed to the `update` function.
- If a part needs to return or pass some kind of result, it should do that in the form of a message wrapped into a command as a result of a call to the `update` function.

When doing it this way, we only use what is already there. There is no need to introduce new concepts. We are using the `init` and `update` functions together with messages and commands to pass information between different parts of the the UI. No need for other fancy stuff.

The API of a part consists of the concrete messages and optionally some business objects it uses to communicate.

## Composing smaller parts

When composing a UI from smaller parts, you effectively build a tree. There are two kind of nodes in this tree: nodes that do real UI stuff (content node) and nodes that compose and coordinate those (structure node). It is very important, that you do not mix those responsibilities. Never let a content node have structural information or let it compose other nodes. Never let a structure node have content on it's own.

There are two kinds of structure nodes:

- choice nodes
- composing nodes

A choice node coordinates several other nodes, but only one of those nodes is active at a time. It is also the job of a choice node to handle the URL based navigation (parse and manipulate the browser URL).

A composing node composes several other nodes that are all active and visible at the same time. It is also the job of a composing node to coordinate and distribute the messages that it's children are sending.

Interestingly the choice node corresponds to a sum type, and the composing node corresponds to a product type. I love functional programming :-)
