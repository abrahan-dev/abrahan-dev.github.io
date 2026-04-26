---
layout: post
title: "Ports And Adapters"
date: 2016-06-06 00:00:00 +0200
categories: ["thoughts"]
excerpt: ""
source_path: "posts/2016-06-06-ports-and-adapters.md"
---
{% raw %}
> Disclaimer: Most of this post are ideas translated / adapted by me during the study. I do not give myself any credit for it, obviously. Hexagonal architecture is a concept developed by Alistair Cockburn. It is necessary to read and reread the advices of Robert C. Martin (Uncle Bob) to understand this ecosystem and the good practices of object-oriented programming.

One of the reasons why a software architecture is necessary is that frameworks as Laravel or Symfony promote a style of code that does not meet the needs of large applications.

When we work on a project from the beginning we have all the control. As the project progresses, a lot of unwritten rules that we usually apply are generated. The problem is that when the application grows and maybe new programmers arrive or maybe some quit the job, all those rules will not necessarily be applied. The code will increasingly be a problem.

Therefore, organizational principles are needed. The best known is MVC.

Software _vedettes_ are always telling us what is right and what is wrong. Finally only you as a programmer know what suits your application according to your means and the general context in which you are. Any decision on architecture and development practices in general should be taken, in my point of view, always taking into account your context. For example, it will not make much sense to apply DDD if our application is a CRUD with 4 controllers. Although of course you can always do it, maybe just for fun.

## MVC is not enough

There is much controversy about whether MVC is architecture or not. In my opinion it is not. I see it as a design guide as DDD can be, although much simpler and not suitable for solving complex problems. Of course, its implementation generates a topology that produces models, views and controllers. In the background the discussion about whether it is architecture or it is a design principle is quite sterile and it does not matter. It is common for programmers to be a pain in the neck about minor details. The main problem I see is that the M of MVC usually has too much work to do, and it is responsible for too many things. Often some of their responsibilities are transferred to the controller, gradually creating too large classes with too many responsibilities, which leads to the title of the following point.

## It is hard to make tests

MVC comes from the frameworks. And a lot of software is intimately linked to the framework in which it was created. This could be an usual work process:

1. Choose a framework.
2. Choose a persistence library.
3. Choose a frontend library.
4. Install the application skeleton.
5. Delete the demo code.
6. Auto-generate entities.
7. Auto-generate the CRUD controllers.

Although this is all very important, it is not the core of our software. All these decisions, taken _a priori_, will make testing slower and more complicated since we will be obliged to instantiate all those elements in order to test a class. There is no doubt that if you are not going to do tests, this will not represent a problem.

In my personal experience I am in a moment in which, after rejecting the frameworks, I want to experiment with them again, since they have undoubted advantages, for example carrying out thousands of tedious tasks that we do not want to program for ourselves. That's fine, but it is necessary to know how to establish the limits of our application and make clear its scope and where the framework ends.

Frameworks encapsulate many details for us, such as transforming a request into a data type such as XML or JSON. Also the communication with the database or the use of the HTTP protocol. However, you have to find a way to work cleanly with them.

## Abstraction

A very important aspect of the development of clean applications is abstraction. Another problem with frameworks is that they are not capable of generating abstraction for us. For example to make a query and extract some data through the persistence layer, the framework will propose very specific elements related to relational databases, methods such as _buildQuery_ or _where_ in addition to seeing the names of fields and tables of databases in the code. It is not abstract, they are rather very specific implementations.

## Coupled code

Another problem with frameworks is that your code is very coupled with the so-called delivery mechanism. Within a framework we will see that usually that delivery mechanism is only one type: The web. Usually the controller will express semantic related to the web and the database. But what happens if we want to execute code from a command line? It will be impossible. The code is very linked to a web controller.

## Reveal intentions

MVC code usually does not show the intent of the code. When reading it, we do not know what it is about, what it does, what is the need or its meaning. If you look at your directory tree, you only see folders like models, views, controllers that do not reveal anything about the behavior of the application.

All this could be very convenient when you make an app development very fast. The code that you get reading the documentation of a framework is usually useful for making CRUDs. How to fix this?

## Hexagonal architecture or Ports and Adapters

We often install the framework and feel that our application is already working. Actually I think that you still have nothing but a lot of code that has nothing to do with your domain.

We have to know how to differentiate between what constitutes our application and everything else. We refer to our application with the term "core":

> The core is what allows us to solve the specific issues of the users of our application in a specific domain.
> The forms of interaction with it are also part of the core, defined in the use cases.

Everything else are details (of the application). It is advisable that our application does not know anything from the outside and it should be only through well-defined interfaces where communication takes place. That is to say that our software is permeable only to the extent that we want. In contrast to a common MVC application embedded in a framework, which is completely infested by the details of the infrastructure implementation.

We call infrastructure everything that is external to the core. These are some examples:

1. Communicating with the web.
2. Communicating with the command line.
3. Communicating with the file system.
4. Communication with the database.
5. Sending emails.

Poor and compact design will ruin the ability to maintain, test and evolve complex systems properly. To alleviate that we have layer architectures that allow us to separate the code, as well as to establish rules to communicate among layers, to establish the boundaries, to help to place our code where it corresponds instead of relying on those "unwritten rules".

Speaking of layers systems, Uncle Bob says something very important that should be highlighted (I transfer the idea, I do not remember the sentence exactly):

> The dependencies can only be from the outside in, that is, a module can only depend on something that is in a lower layer and never the other way. Therefore, our core should never know anything about the outer layers.

## Ports

To cross the limits we send messages in our code. These messages can be functions and arguments. The limits of the application are in the inputs ports. A message comes from the outside and if you want your app to communicate with the outside you have to establish an input port that allows it.

## Adapters

For example, the typical case on the web would be a port that uses the HTTP communication protocol. Whenever there is a port, there is some type of translation or transformation that is carried out by an adapter, in such a way that a web request can be processed. An adapter would therefore be a group of classes that can transform an external request, for example in the web, into something that can be treated by the domain layer.

> "Ports and adapters" is an alias for hexagonal architecture.

Ports provide communication Adapters translate messages from the outside so they can be treated inside. For example, a web request will be converted into a command object. This object reveals its intentions thanks to its name and it has nothing to do with the delivery mechanism (the web), is therefore self-contained and it loses its relation with the outside world. This command object is only a message and does not take any action. Then a handler will accept the command and do what is necessary for the action to be processed.

If the action involves persistence, a persistence port that could act on any target type, for example a database, will be used in the same way. The particularity here is the following:

In a classic design our domain (core) will usually have a class that depends on a repository located in the infrastructure layer. For example:

1. Core.
2. usersRepository (Class).
3. Infrastructure.
4. queryBuilder.
5. entityManager.

The `usersRepository` depends on the `queryBuilder` and the `entityManager`. As we have seen previously, our core can not depend on classes located outside the domain (in external layers). To solve this dilemma we have to use dependency inversion:

1. Core.
2. usersRepository (Interface) Our domain defines the interface, it does not know anything about the implementation details of the persistence.
3. Application layer.
4. usersRepositoryHandler.
5. Infrastructure.
6. usersRepository (Implements the interface). We can add any implementation as long as it respects the interface, for instance we would like to connect with another type of persistence.

Within our domain we will define a repository interface in the application layer and we will have a handler that will use the repository. The repository will depend on the interface, not on the concrete implementation. In the infrastructure layer we will have a repository that implements the interface to create a specific type of persistence.

## What is all this for?

Separation of concerns. We will have several layers to distribute our code:

1. Core.
2. Domain layer.
3. Application layer.
4. Infrastructure.

We are sure to put our code in the correct layer. It is a principle of organization that helps in applications of certain complexity.

We have cases of use with commands and handlers that perform the action that our application must perform. This isolates our core.

The hexagonal architecture supports very well diverse design methods such as BDD, TDD or CQRS. It could also be applied in micro-services, obtaining many small hexagons.

This let you write your application as if the outside world did not exist, and then connect it, creating ports and adapters. This is very interesting to make tests.

## Conclusion

I firmly believe in the advantages of delaying (whenever it is possible) all the decisions related to the infrastructure layer. It is better to create a solid and testable domain, establishing the ports and adapters that will later let us connect our application and the outside world. At the beginning we can mock those boundaries and work comfortably for example using TDD.
{% endraw %}
