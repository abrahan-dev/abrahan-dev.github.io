---
layout: post
title: "Simplicity In Code"
date: 2022-11-10 00:00:00 +0200
categories: ["thoughts"]
excerpt: ""
source_path: "posts/2022-11-10-simplicity-in-code.md"
---
{% raw %}
It is always difficult to define a concept that is generally used in a subjective way, meaning different things. When we say that something is simple, it could have positive or negative connotations depending on the context and the intention.

Regarding programming, simplicity could be the result of breaking down complex needs into simple things so that we can compose without too much hustle. Saying that "something is simple" often means that it is easy to understand and use.

## The love and death of object oriented programming

I believe that OOP is a paradigm that does not bring a lot of help in the crusade to divide and conquer complexity, instead it feeds up the agglomeration of ideas and concepts into (very often) low quality abstractions.

Because we have built OOP, we need design patterns. Maybe OOP tends to make simple things complex, while FP (functional programming) tends to make complex things simple. If we use simpler blocks that relate more naturally, then we do not really need design patterns.

OOP is still the best way I know to tackle the problem for most of the people. I would just not go so far why my OOPness unless I am sure about what I am doing. It is enriching to know other ways and it might not be the best.

## A good programmer

A good programmer can have many qualities, but an indispensable one is being able to make good abstractions. After many years developing OOP I think that OOP does not help _per se_.

Another quality is being able to translate complex business ideas into simple/testable code. Easy to say.

## A few rules

Simplicity is likely to be achieved with a combination of ideas from various paradigms, including OOP and FP, where data and functions are first-class citizens, while classes are used mainly to guarantee [invariants](/archive/)#Invariants_in_computer_science>).

-   Separate data from code
-   Use immutable data whenever possible. It may be inefficient in data science, but most applications can take advantage of it
-   Use generic data structures. If a hash map is all what you need, use it
-   Use data as a first class citizen
-   Use json as it is, in native form without transformations / proxies...
-   Say things in a more declarative way
-   Do not share more than you’d like to

## Where is my function?

I am not an expert FP programmer, just an _aficionado_, but given the amount of work that OOP code need and the cost per bug, I'd say that classes are not efficient tools by design. With FP the cost per bug can be reduced at a price: the granularity of the system can be overwhelming. How do we write our functions and organize them is key.

## Conclusion

How do we update our mental models to accommodate simplicity?: Think first data and functions, then classes for invariants.

Let me digress here. We have a very few things to do with code, and we do it again and again:

-   assigning a variable
-   calculating something
-   evaluating a condition
-   looping over a collection
-   generate a side effect

As stated in the great book "The case against reality" by Donald Hoffman, _evolution optimizes for fitness, not for truth_. Maybe programmers also optimize for something that is just an interface, not for discovering the truth underneath the abstraction. We depend heavily on space (computational structures repetition) and time (loops/recursion).

I think true simplicity will come whenever we get rid of those (space and time). There is A LOT of repetition in every code base. We are always using the same code-phrases to achieve the same results like homogeneous transformations of inputs into outputs or performing side-effects.

We spend a lot of time iterating over collections of data. What if we could just update every element of the collection in a single computational unit of time without any iteration at all? In that case we would accept that space and time are indeed beautiful abstractions, not reality.

But hey, I'm just a programmer, not a physicist.
{% endraw %}
