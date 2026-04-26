---
layout: post
title: "Thoughts On DDD"
date: 2016-05-25 00:00:00 +0200
categories: ["thoughts"]
excerpt: ""
---
{% raw %}
> At the end, everything is about the customer's happiness and the programmer's happiness.

When I said that at the office I didn't know that I was promoting Domain Driven Design.

Microservices, self-contained systems, domain driven design and others, what they really want for all the actors within a particular domain is to maximize their performance and happiness. The company needing a high quality software solution will obtain a medium-term benefit. The programmers will design step by step an application they can trust and the managers will stop pulling their hair out.

## Divide and conquer

When I look a little closer at these methodologies, I have the impression that they all look too much alike, even with their big differences. It's like they all emanate from the same source: the need to separate responsibilities at all levels. The Single Responsibility Principle allows a good start in any software development story, by taking time to define:

1. The model of your domain.
2. The objects that inhabit it.
3. Its needs.
4. The data that circulates and the way of transmitting it and relating it.
5. The services and the infrastructure that exist in the represented and immaterial world of software.

...what you were doing is divide once again.

When applications began to grow exponentially and the pioneers of this profession noticed that they were losing control, some rules were needed to help organize complex systems.

## Let's talk

Apparently there was a chasm between the teams developing the software and those carrying out the "main" business activity (what everyone would identify as the source of profit).

And the software then, what is it? What DDD promotes in teams is to develop a common language, used by domain experts and developers as well. This means many things, for example your creepy variable $arrayB that only you barely know what it is will become $bookings. Your functional tests could become a contract, or even a source of documentation which is meaningful for both domain experts and software designers. In order to achieve that, many hours of common conversation will have taken place in the meeting room.

When everyone shares the same concepts, the same domain semantics: we have reached the nirvana of the DDD and our software must reflect it.

## What is all about

It is about modeling your software following an hermeneutic of domain. Which means that once we know the world that our software must represent, solving it using DDD, provides us with a framework in which to work with a guarantee: this world will not become immediately incomprehensible, monolithic and impossible to verify (untested spaghetti code).

It is about creating complex systems based on high quality software.

> DDD is not architecture.

DDD is about discovering little by little the domain, interacting with the experts, generating little by little the ubiquitous language, bringing value and knowledge to the business.

Show me the money!

## Conclusion

Complex systems need ways to be built, to be organized and integrated, as well as defined ways of working and understanding the profession (a moral, a philosophy?). I see a little bit of all that in the DDD.

> DDD provides a syntactic analysis for the software architecture.

From a more technical point of view, if you like to apply DDD to your application, in addition to improving communication with the client and being an expert of the domain, you must know how to use Domain Services, Value Objects, Modules, Aggregates, Entities, Domain Events, Factories or Repositories.
{% endraw %}
