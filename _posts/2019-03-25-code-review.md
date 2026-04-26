---
layout: post
title: "Code Review"
date: 2019-03-25 00:00:00 +0200
categories: ["talks"]
excerpt: ""
---
{% raw %}
I've recently watched a great keynote about code reviews presented by Trisha Gee during the SCLConf 2018. You should go directly to the source which I link below. This is kind of TL;DR

Disclaimer: I usually take notes when watching videos I am interested in
because it helps me to remember the highlights and order the ideas. So I do not take any credit of it. I eventually add my own ideas or opinions but not necessarily. I am just ordering the content in a way that it is useful for me after.

So we need to have an opinion about the code we read. Read code is different from writing code: we are way more critics with others.

So what we look for in others code... it depends.

Anti-patterns in code review:

-   Nitpicking (formatting, whitespace, method length...).
-   Design changes when the code works.
-   Inconsistent feedback (criteria change).
-   The ghost reviewer (reviewer never shows).
-   Ping-pong reviews (first review something, second review something else...).

From my personal experience, I suffered a lot all of them, it bothers me specially the inconsistent feedback and ping-pong reviews. Both depend greatly on the reviewer culture and state of mind.

> Sometimes a have to review the reviewer during the review.

I started making a great effort to agree upon the code with the team before actually writing any code, in order to avoid design changes during the code review, what it eventually means a pull request declined. We avoid nitpicking by automation, using tools like phpcs, ide capabilities and plugins for checking code standards like [PSR2](https://www.php-fig.org/psr/psr-2/).

Why?

-   Find bugs.
-   Share knowledge.
-   Check code is understandable.
-   Ensure code does what it's supposed to do (tests).
-   Evolve the code in a particular direction.

When to do the code review?

-   During implementation.
-   When is ready to merge.
-   After being merged.

Me personally do not ask for reviews after being merged. I use to request a pull and the code review is made before merging. Lately I am finding useful to ask for micro reviews during development (specially if there is a gate keeper, I probe his or her opinion during the process). It saves a lot of time during the code review, especially concerning all the opinionated stuff.

When is the review complete.

-   When everyone agrees.
-   When a gate keeper agrees.
-   When all comments are addressed.

I am usually working with a gate keeper so when the pull requests have a certain degree of complexity, everyone expects gate keeper's approve to move on. Sometimes I write a comment and it is not even responded. I usually find that a great thoughtlessness.

Who reviews the code.

Who says It is done

Where

-   Doing code review by pair programming.
-   Remote screen sharing.
-   On the IDE, checking out a commit or a branch.

Most of the cases for me it is on the IDE, checking out branches.

Things to look for:

-   Fit overall architecture.
-   Solid, DDD, Design patterns.
-   New code follows teams current practices.
-   Code is in the right place.
-   Code reuse.
-   Over-engineering.
-   Readable code and tests.
-   Testing the right things.
-   Exception error messages.
-   Subtle bugs.
-   Security.
-   Regulator requirements.
-   Performance.
-   Documentation is updated.
-   Spelling, punctuation and grammar.

How?

-   Automated everything you can.
-   Submit small amounts of code.
-   Describe the code review (i choose this and this because ....).
-   Respond as soon as possible (the coder is multitasking or blocked).
-   The reviewer has a list of problems to check.
-   Put the comments in context.
-   Be constructive.
-   Be specific.
-   Say what have to be addressed to accept the code (prioritize).
-   Respond to the comments.

I like very much the final phrase of Trisha, something like: the aim is to put code in production, not to show others how smart whe are as programmers.

We are definitely narcissistic people.
{% endraw %}
