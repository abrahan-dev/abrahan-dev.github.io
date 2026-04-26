---
layout: post
title: "Exceptions And Errors"
date: 2024-08-26 00:00:00 +0200
categories: ["thoughts"]
excerpt: ""
source_path: "posts/2024-08-26-exceptions-and-errors.md"
---
{% raw %}
## Why do we need to avoid generic exceptions?

Why should I create specific domain-related exceptions?

-   Fragility. The code handling the exception might rely on the structure or message of the exception. It’s better to create our own exception. In TypeScript, this means that depending on built-in or third-party exceptions (like relying on specific error messages or properties) can make your code fragile. If the structure of these exceptions changes, it might break the error-handling logic. Instead, creating your own custom exception class gives you more control and makes your code more robust.

```typescript
class PostContentException extends Exception {}
```

-   Specificity. It allows us to handle exceptions in a more precise way and make better decisions. In TypeScript, creating custom exceptions improves the specificity of error handling. This means you can catch and respond to particular errors more accurately instead of catching general exceptions. It leads to better decision-making based on the type of error.

```typescript
class PostContentIsEmptyException extends PostContentException {}

class PostContentIsTooShortException extends PostContentException {}
```

-   Encapsulation. It allows us to encapsulate exception-handling logic in one place. We can store the state of the exception, for example, by passing data to it through the constructor and storing the message internally. In TypeScript, creating custom exceptions allows you to encapsulate both the error-handling logic and any relevant data within the exception itself. This improves the maintainability of your code by centralizing the logic and storing the exception’s state in a structured way.

```typescript
class PostContentIsTooShortException extends PostContentException {
    constructor(content: string) {
        super(`The content "${content}" is too short`)
    }
}
```

## When and how to throw exceptions?

In a post search method, our post repository service might either find something or find nothing.

From the repository’s perspective, not finding anything isn’t an error—it’s an expected result that is made explicit in the return type. Therefore, we shouldn’t throw an exception in this case.

It’s the repository client’s responsibility to decide what to do when nothing is found. For instance, if the client is a use case that searches for a post by its ID and doesn’t find it, it could throw a PostNotFoundException, which could then be caught by a controller and return a 404 via the HTTP interface.

Whether not finding something is an error depends on the context. For example, if my API has an endpoint that looks up posts based on known IDs from a database and doesn’t find a post with an expected ID, then that is an error. However, if I have an endpoint that searches for posts based on a search criterion and finds nothing, that’s not an error, especially if user inputs are involved.

Throwing exceptions can also be costly in terms of performance, so we need to be careful not to overuse them. Sometimes, throwing an exception from a service may force us to add a try-catch block in a method that shouldn’t have one, creating the problem of having to handle an exception that doesn’t belong there.

One way to distinguish between Errors and Exceptions is that Errors represent things we can control within our domain (UserNotFoundError), while Exceptions represent something uncontrollable, such as infrastructure failures (a database crash, network failure, etc.).

The “problem” I often encounter here is that I tend to model errors for which I don’t have a specific behavior or reaction. This seems like a case of premature error optimization.

These non-generic errors can provide great clarity in the code when I read it. However, most of the time (in my case), they tend to be caught in the same catch block of a controller or service that normalizes the treatment upstream, like a funnel. The subtypes get dissolved into more generic types.

I would argue that even if I don’t have a specific catch block for a specific error, it still adds semantic value and can help with things like identifying issues later in a log aggregation system.

I understand why other ideas have emerged, such as treating errors as return values. If something can happen and it’s not exceptional, then it should be part of the method’s signature. But of course, we can’t type exceptions in many languages. And if something is truly exceptional, we shouldn’t worry about it in our code (I’m optimistic and assume the database connection works).

## How to test exceptions?

To test exceptions, we can use Jest’s `expect().rejects.toThrow()` method.

We provide the subject under test with the necessary data to trigger the exception, and then verify that it indeed throws the expected exception.

It’s important to test not only that the correct type of exception is thrown, but also that the content of the exception matches what we expect.

To prevent unexpected errors from causing the tests to fail unnoticed, if the object under test has constants that might trigger an exception during creation (e.g., a MAX_LENGTH), it’s a good idea to hardcode the value in the test. This ensures that if the value is mistakenly changed in the object, the test won’t continue passing silently.

In the case of TypeScript, it’s crucial that objects are created using constructors so that validation rules are applied, rather than simply creating objects with the correct structural shape.

## Exceptions from other modules

When dealing with exceptions from other modules in my own, I need to test their exceptions the same way I would test my own. This coupling can become a problem if the module is promoted to a higher-level context or deployed as a separate microservice.

In other architectures, like CQRS, this coupling might be managed differently. It depends on the specific case. In our tests with coupled modules, we’ll mock the repositories and create a state that triggers the desired exceptions.

## Mapping exceptions to HTTP status codes

We can map exceptions to HTTP status codes within a controller. For instance, if we throw a PostNotFoundException, we can catch it in the controller and return a 404 status code.

Depending on the framework we use, the exception could contain a structure defined by us, allowing us to return an error message, error code, etc., by creating a custom error type that includes the necessary information within a framework-specific error.

This pattern will likely repeat often in the code (use case, try-catch). We can factor this into a method that takes the use case and an error-handling function, centralizing this pattern in one place and simplifying the controllers.

It’s a bit of a hack for TypeScript, but personally, I wouldn’t mind repeating this structure a thousand times in the controllers.

## How to treat all the possible exceptions

```typescript
type Errors =
    | UserNameTooLongError
    | UserPostAlreadyLikedError
    | PostAlreadyExistsError

function _handleErrors(error: Errors): void {
    switch (error.type) {
        case 'UserNameTooLongError':
            // instead of using strings, we can create a type property within the error:
            // type PostAlreadyExistsError = {
            // 	  readonly type: "PostAlreadyExistsError";
            // 	  message: string;
            // };
            // and the switch will be something like this:
            // switch (error.type) {
            //     case "PostContentIsEmptyError":
            // 		 case "PostContentTooLongError":
            // 		     return HttpNextResponse.domainError(error, 400);
            // 		 default:
            // 		     assertNever(error);
            // 		 }
            console.log('User type is too long')
            break
        case 'UserPostAlreadyLikedError':
            console.log('User already liked this post')
            break
        case 'PostAlreadyExistsError':
            console.log('Post already exists')
            break
        default:
            const exhaustiveCheck: never = error

            return exhaustiveCheck
    }
}
```

## Alternatives

### Option / Maybe / Optional

```typescript
type UserPrimitives = {
    name: string
    email: string
    age: number
}

function findUserById(id: number): Promise<Optional<UserPrimitives>> {
    // ...
}
```

In this case, we don’t need to manage null or exceptions. Instead, we create an Optional object that uses methods like map or fold to access the data.

While this optionality can add some noise to the code when dealing with domain-level errors, it can be useful in other cases.

### Either / Result

Either allows the signature of the function to have typed errors.

```typescript
type UserPrimitives = {
    name: string
    email: string
    age: number
}

type UserError = {
    type: 'UserNotFoundError'
}

type UserResult = Either<UserError, UserPrimitives>

function findUserById(id: number): Promise<UserResult> {
    // ...
}
```

We can combine Either with Option to create a type that allows us to handle both errors and optional values.

```typescript
type UserPrimitives = {
    name: string
    email: string
    age: number
}

type UserError = {
    type: 'UserNotFoundError'
}

type UserResult = Either<UserError, UserPrimitives>

function findUserById(id: number): Promise<UserResult> {
    const user: Optional<User> = await userRepository.findById(id)

    user.fold(
        () => Either.left(new UserNotFoundError()),
        (user) => Either.right(user.toPrimitives())
    )
}
```

Using Result with Optional instead of Either with Optional is very similar; only the data access API changes (using error and ok instead of right and left).

## Conclusion

Result and Either are a good alternative to exceptions, but they are not a panacea. It’s important to note that they are not very common in most languages and frameworks, so implementing and maintaining them can be a bit more complicated.

On the other hand, Result is semantically clear in terms of error handling and is very robust. For truly exceptional cases, exceptions remain a good option.

One problem with Result is when dealing with multiple types of errors and combining them into a single error without interrupting the execution flow.

Another issue is their use in constructors, since we cannot return a Result from a constructor. Therefore, if we want to validate an object upon creation, we cannot use Result unless we employ a factory method and private constructors.

In summary, in TypeScript, it seems that using exceptions is still the best option today, although it’s worth considering that there are alternatives that can be useful in certain cases.
{% endraw %}
