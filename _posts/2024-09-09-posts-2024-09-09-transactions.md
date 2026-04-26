---
layout: post
title: "Transactions"
date: 2024-09-09 00:00:00 +0200
categories: ["thoughts"]
excerpt: ""
source_path: "posts/2024-09-09-transactions.md"
---
{% raw %}
## Repository

In this approach, transactions are managed within the repository. For example, we might have a `save` method that initiates and finalizes a transaction.

This setup can make sense if the repository method performs several operations that must remain invariant. However, in my experience, this is seldom an issue; typically, a `save` or `update` method in a repository involves only a single query.

To avoid duplicating transaction management code in every repository function, we could pass the content of the `save` or `update` function as an argument to another function called `transactional` that handles the transaction details.

In this case, I wouldn't write tests specifically for the transactions, as that can be cumbersome and offers little benefit. I'm optimistic that this will work as intended.

To make the transaction optional, we could use the decorator pattern by wrapping the non-transactional repository with a `Transactional` repository.

## Use Case

Alternatively, the transaction can be a dependency alongside the repository in the use case or application service. The issue we might face is that the interfaces implementing the database connection become too similar to their implementations, creating a coupling between the specific database and our use case. Ideally, our use case code should not be aware of the persistence system.

We might encounter concepts like `begin transaction`, `commit`, and `rollback` within the use case, which could be mitigated with somewhat convoluted abstractions that may not be worth the effort.

Testing this use case becomes a bit more complicated with tests like "shouldCommit".

The advantage is that we have all the critical elements of our use case controlled by the transaction. However, the dependency injection and tests have become considerably cluttered with database engine–specific semantics.

This problem can be somewhat improved by decorating the use case with the transaction. The structural coupling remains the same, but we have hidden the complexity in a higher layer. The tests become clean again.

## Controller

In this approach, we simply place our `transactional` function in the controller, wrapping all its actions. We create the connection and the necessary repositories for our use cases within the controller.

The advantage is that everything remains very clean; the use cases no longer contain any database-specific code, and the tests are simplified. Structural coupling is limited to the infrastructure layer.

I assume that a transaction is necessary and that we cannot or do not want to resort to event-driven architectures, which might be more suitable in certain scenarios.

But how can we roll back a non-transactional action that occurs outside our system (such as sending an email or publishing an event to RabbitMQ)? To handle this, we can use the deferred pattern and implement a `sendDeferredEmails` method in a decorator of `EmailSender`, called `EmailSenderDeferred`, for example. When we request to send an email, it doesn't actually send it immediately but places it in a stack that it manages internally. We call the `sendDeferredEmails` method when we are sure that the transactional actions have succeeded.

Meanwhile, the transactional actions that had an `EmailSender` injected call the `sendEmail` method as needed without worrying about the implementation details. The drawback is that we need to trust that the deferred actions will be handled appropriately. Related to this is the Outbox Pattern, which is useful for transactions in distributed systems.

The controller can also be decorated with middleware, depending on the framework we use.
{% endraw %}
