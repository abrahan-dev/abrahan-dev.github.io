---
layout: post
title: "Database Views"
date: 2024-10-01 00:00:00 +0200
categories: ["learning"]
excerpt: ""
---
{% raw %}

## When Views Are Useful

In legacy systems, particularly those with numerous tables and where making modifications is challenging, you may want to define new concepts in repositories that isolate your code from this complexity (an anti-corruption layer).

This could result in complex data searches within a search method, where queries involve multiple levels of indentation and complexity.

To simplify these queries, we can create a view. A view operates at the logical level without modifying or storing the resulting data. Thanks to this, the search or searchAll methods in our repository become much simpler.

A view acts as an alias for the original query, offering the benefit of cleaner and more maintainable code. However, it comes with its own challenges, as the view itself will also need maintenance. The computational cost of executing a view remains the same as that of the original query.

## Materialized Views

As the volume of data grows (and it doesn’t need to be massive) and query complexity increases, regular views may become inefficient.

A materialized view is precomputed, meaning the results of the query are stored in memory, making data retrieval as efficient as accessing any regular table without the overhead of re-executing the query each time.

Materialized views are updated at specific times, such as during data writes or at scheduled synchronization points.

If new data is added to the underlying tables, a materialized view may not immediately reflect the latest data, unlike a regular view, which always returns the most current version.

The process of refreshing a materialized view depends on the database engine, and the computational cost is incurred during this refresh. It’s crucial to plan when and how often the refresh should occur to avoid performance issues.

In PostgreSQL, for instance, materialized views do not automatically refresh, while Oracle does support auto-refresh under certain conditions. However, auto-refresh or scheduled refreshes can be risky, as we lose control over the potential computational cost. In scenarios involving large datasets or complex calculations, this can become a significant concern.

## Triggers

Without auto-refresh, we can also rely on triggers to update the data. A trigger can update a specific table when a certain event occurs in another. In this case, the computational cost occurs during data writes, handled by the database engine.

However, this process is somewhat hidden from the code, making it difficult to trace how updates occur. In many cases, we might prefer handling this in our application code using domain events (projections), while in other cases, infrastructure-level triggers can manage it.

The advantage of this approach, whether through domain events or infrastructure triggers, is that projections stay up-to-date incrementally, rather than by recreating the entire view. This method reduces the computational load by performing smaller, more manageable updates.

There are also sophisticated Change Data Capture solutions like Debezium, which can capture these triggers and use the data more effectively, providing a simpler alternative to handling these updates manually.

## Alternatives

As an alternative to views, we could use a simple repository if ultra-fast read performance is not a critical requirement. Materialized views can be leveraged for better execution times, with an understanding of the limitations specific to each database engine.

We can implement projections using triggers, either by creating them ourselves or utilizing more advanced tools depending on the complexity of the system. Another option is to manage projections with domain events within our codebase. Each approach depends on the specific needs of the application and the trade-offs we are willing to accept.
{% endraw %}
