---
layout: post
title: "Algorithms and Problems"
date: 2013-01-25 00:00:00 +0200
categories: ["algorithms"]
excerpt: "A single collection of TypeScript algorithm and coding problem implementations."
---
{% raw %}

## Binary Search

```typescript
export function binary_search(search: number, haystack: number[]): number {
    return search_recursive(0, haystack.length - 1, search, haystack)
}

function search_recursive(
    left: number,
    right: number,
    search: number,
    haystack: number[]
): number {
    let key = -1
    const middle = Math.floor((left + right) / 2)

    if (left <= right && middle in haystack) {
        if (haystack[middle] < search) {
            key = search_recursive(middle + 1, right, search, haystack)
        } else if (haystack[middle] > search) {
            key = search_recursive(left, middle - 1, search, haystack)
        } else if (haystack[middle] === search) {
            key = middle
        }
    }

    return key
}
```

## Berlin Clock

```typescript
export function berlin_clock(
    time: string | null = null,
    row: number | null = null
): string {
    const formatTime = (time: string | null): [number, number, number] => {
        const timeString =
            time || new Date().toLocaleTimeString('en-GB', { hour12: false })
        const [hours, minutes, seconds] = timeString.split(':').map(Number)
        return [hours, minutes, seconds]
    }

    const singleMinutes = (minutes: number): string => {
        const bulbsOn = minutes % 5
        const totalBulbs = 4
        return 'Y'.repeat(bulbsOn).padEnd(totalBulbs, 'O')
    }

    const [hours, minutes, seconds] = formatTime(time)
    const berlinTime: Record<number, string> = {
        0: singleMinutes(minutes),
    }

    return row !== null ? berlinTime[row] : Object.values(berlinTime).join('')
}
```

## Contains Duplicate

```typescript
// Given an integer array nums, return true if any value appears
// at least twice in the array, and return false if every element
// is distinct.

export function contains_duplicate(nums: number[]): boolean {
    const set = new Set<number>(nums)
    return set.size < nums.length
}
```

## Factorial

```typescript
// time complexity: O(n)
// space complexity: O(1)
export function factorial(num: number): number {
    let factor = 1,
        response = 1

    while (factor <= num) {
        response *= factor
        factor++
    }

    return response
}
```

## Fibonacci Bottom Up

```typescript
export function fibonacci_bottom_up(num: number): number {
    const sequence: number[] = []

    for (let k = 1; k <= num; k++) {
        let f: number

        if (k <= 2) {
            f = 1
        } else {
            f = sequence[k - 1] + sequence[k - 2]
        }
        sequence[k] = f
    }

    return sequence[num]
}
```

## Fibonacci Memoized

```typescript
export function fibonacci_memoized(
    number: number,
    memo: Record<number, number> = {}
): number {
    if (memo[number]) {
        return memo[number]
    } else if (number <= 2) {
        return 1
    } else {
        const fib =
            fibonacci_memoized(number - 1, memo) +
            fibonacci_memoized(number - 2, memo)
        memo[number] = fib
        return fib
    }
}
```

## Fibonacci Naive

```typescript
export function fibonacci_naive(number: number): number {
    if (number <= 1) {
        return number
    } else if (number === 2) {
        return 1
    } else {
        return fibonacci_naive(number - 1) + fibonacci_naive(number - 2)
    }
}
```

## Find Longest Word Length

```typescript
export function find_longest_word_length(str: string) {
    return str.split(' ').reduce(function (previous, current) {
        return previous.length > current.length ? previous : current
    }).length
}
```

## Fizzbuzz

```typescript
// https://www.codurance.com/katalyst/fizzbuzz

export function fizzbuzz(number: number) {
    const isFizz = number % 3 === 0
    const isBuzz = number % 5 === 0
    const numberOfFizzs = (number.toString().split("3").length - 1)
    const numberOfBuzzs = (number.toString().split("5").length - 1)
    let result = number.toString()

    if (isFizz && isBuzz) {
        result = "FizzBuzz"
    } else if (isFizz) {
        result = "Fizz"
    } else if (isBuzz) {
        result = "Buzz"
    }

    return result
        + "Fizz".repeat(numberOfFizzs)
        + "Buzz".repeat(numberOfBuzzs)
}
```

## Largest Number Of Each

```typescript
export function largest_number_of_each(arr: number[][]) {
    return arr.map(function (current) {
        return current.reduce(function (previous, current) {
            return previous > current ? previous : current
        })
    })
}
```

## Palindrome

```typescript
export function palindrome(str: string) {
    let cleanStr = str.replace(/[^0-9a-z]/gi, '').toLowerCase()
    let reverseStr = cleanStr.split('').reverse().join('')

    return reverseStr === cleanStr
}
```

## Prime Factors

```typescript
export function prime_factors(number: number): number[] {
    const numbersList: number[] = []

    for (let maybePrime = 2; number > 1; maybePrime++) {
        while (number % maybePrime === 0) {
            numbersList.push(maybePrime)
            number /= maybePrime
        }
    }

    return numbersList
}
```

## Reverse String

```typescript
export function reverse_string(str: string) {
    return str.split('').reverse().join('')
}
```

## Running Sum

```typescript
// time complexity: O(n)
// space complexity: O(n)
export function running_sum(numbers: number[]): number[] {
    let result: number[] = new Array(numbers.length)
    result[0] = numbers[0]

    for (let i = 1; i < numbers.length; i++) {
        result[i] = numbers[i] + result[i - 1]
    }

    return result
}

// time complexity: O(n)
// space complexity: O(1)
function running_sum_alternative(numbers: number[]): number[] {
    for (let i = 1; i < numbers.length; i++) {
        numbers[i] += numbers[i - 1]
    }

    return numbers
}
```

## String Calculator

```typescript
class Human_String_Calculator {
    public add(input: string): number {
        const delimiter = this.extract_default_delimiter(input)
        const pattern = new RegExp(`[\\n${delimiter}]`)
        const numbers = input.split(pattern)
        return this.process_list_of(numbers)
    }

    private extract_default_delimiter(input: string): string {
        let delimiter = ','
        const matches = input.match(/\/\/(.*)\n(.*)/)
        if (matches && matches[1]) {
            delimiter = matches[1].replace('[', '(').replace(']', ')')
        }
        return delimiter
    }

    private process_list_of(numbers: string[]): number {
        let sum = 0
        const negatives: number[] = []

        for (const numberStr of numbers) {
            const number = parseInt(numberStr)
            if (isNaN(number)) {
                continue
            }
            if (number > 1000) {
                continue
            }
            if (number < 0) {
                negatives.push(number)
            }
            sum += number
        }

        if (negatives.length > 0) {
            throw new Error(`Negatives not allowed: ${negatives.join(',')}`)
        }

        return sum
    }
}

// ChatGpt Version created from the tests
export class String_Calculator {
    add(input: string): number {
        if (input === '') return 0

        let delimiters = [',', '\n']
        let customDelimiter = input.match(/^\/\/(\[.*\])\n|^\/\/(.+)\n/)

        if (customDelimiter) {
            input = input.split('\n')[1]
            if (customDelimiter[1]) {
                // Handle multiple custom delimiters of any length
                delimiters = customDelimiter[1].slice(1, -1).split('][')
            } else {
                // Single custom delimiter
                delimiters = [customDelimiter[2]]
            }
        }

        const delimiterRegex = new RegExp(
            `[${delimiters
                .map((d) => d.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'))
                .join('|')}]`
        )
        const numbers = input.split(delimiterRegex).map(Number)

        // Handle negative numbers
        const negatives = numbers.filter((n) => n < 0)
        if (negatives.length) {
            throw new Error(`Negatives not allowed: ${negatives.join(',')}`)
        }

        // Sum numbers, ignoring those greater than 1000
        return numbers.reduce((sum, num) => (num <= 1000 ? sum + num : sum), 0)
    }
}
```

## Tamagotchi

```typescript
export class Tamagotchi {
    private _hungriness: number = 0
    private _fullness: number = 0

    get hungriness(): number {
        return this._hungriness
    }

    get fullness(): number {
        return this._fullness
    }

    public feed(quantity: number): void {
        this._hungriness -= quantity
        this._fullness += quantity
    }
}
```

## Title Case

```typescript
export function title_case(str: string) {
    let titleWords = str.split(' ').map(function (word) {
        var titleWord = ''

        for (var i = 0; i < word.length; i++) {
            titleWord += i === 0 ? word[i].toUpperCase() : word[i].toLowerCase()
        }

        return titleWord
    })

    return titleWords.join(' ')
}
```

## Truncate String

```typescript
export function truncate_string(str: string, num: number) {
    var end = '...'
    var num_chars = str.slice(0, num)
    if (num < end.length) {
        return num_chars + end
    }
    if (num == str.length) {
        return str
    }
    if (num < str.length + end.length && num > str.length) {
        return str
    } else {
        return num_chars.substring(0, num_chars.length - end.length) + end
    }
}
```

{% endraw %}
