---
layout: post
title: "Projections"
date: 2024-11-17 00:00:00 +0200
categories: ["learning"]
excerpt: ""
---
{% raw %}
Projections help when we encounter performance issues in the database due to queries involving many joins.

Imagine we’ve modeled several entities in our domain: Book, Author, and Genre. Now, instead of using these entities separately, we need to combine them to create a new aggregate called Product for the front end. In this case, we could face the performance issues I mentioned earlier.

Some solutions to address this include: Repositories, Views, Materialized Views, and Projections.

With repositories, the queries are hidden behind the anti-corruption layer, which is the interface, the repository contract in our domain.

With views, the complex query is simplified in the repository implementation and becomes a simple query on the view.

In terms of performance, we haven’t gained much because the view functions only as an alias, and the query is executed each time we use it.

If the view is materialized, the result of executing the query exists in the database, making it much faster to read. However, materialized views are not always feasible and have some downsides.

In the case of projections, the responsibility for updating the view lies with the application, not the database. This can be over-engineering in many cases. For example, we can achieve this through domain events. If I’ve created a Car entity in one context, I can emit the “car created” event, which might be consumed by another context that then updates a car count elsewhere or modifies a view of new cars, etc.

It’s also true that we might consider a database trigger a type of projection since it works similarly by reacting to events. In this case, the responsibility lies with the infrastructure layer without negatively affecting our code.

Projections are prepared at the time of reading, which doesn’t require additional computation. The cost is during the write operation.

They don’t work in real-time because a query may not return completely up-to-date results, as there’s a delay between when the projection acts and when the data is updated.

Those updated data, by the way, are sometimes redundant. For example, if I create a projection of a car model name in the “sales” table, I’ll have the car name in two tables.

Replacing complex queries with projections removes certain joins and will be very optimized for reading at the cost of programming the projections. Maintenance will be more complex.

One advantage of projections is the ability to have data distributed across multiple databases and modify them without joins, which would otherwise be impossible, but with projections, it becomes feasible.

## Implementation

`Use case -> Entity.create -> Repository.save -> EventBus.Publish`

In another context, a subscriber will consume that published event.

In the case of a projection, we’ll see that the changes made by the first use case project those changes through events into other entities in other contexts.

To test this, we need to create the event and test the subscriber when the event is passed to it.

Thanks to projections, data reading becomes much simpler, and we can often avoid joins. For instance, if creating a “like” on a post results in creating that like in the database and, via the projection, increasing a like counter on the Post entity, when we read the posts, we’ll already have the likes without needing to join with the likes table. However, to achieve this, a lot of code will need to be written, including event management and additional tests.

This scalability applies to data reading performance, but also to the segregation of contexts, where events can create clear boundaries between them. Scalability also applies to software teams for that matter.

If we don’t need both, projections will be over-engineering. The dependency between teams will never be completely eliminated, and this could lead to friction.
{% endraw %}
