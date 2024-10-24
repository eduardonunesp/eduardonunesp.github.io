+++
title = "Exploring Binary Search in Go: Iterative and Recursive Implementations"
slug = "exploring-binary-search-in-go"
date = "2024-06-02"
+++

Binary Search is a fundamental algorithm in computer science, renowned for its efficiency in searching through sorted datasets. In this article, we'll delve into two generic implementations of Binary Search in Go (Golang): an **iterative** approach and a **recursive** approach. We'll explore how these implementations work, their time and space complexities, and the benefits of using generics with Go's `cmp.Ordered` constraint.

## Introduction to Binary Search

Binary Search is an efficient algorithm for finding an item from a sorted list of items. It works by repeatedly dividing the search interval in half:

1. **Start** with an interval covering the whole array.
2. **Compare** the target value to the middle element of the array.
3. **If** the target value matches the middle element, the position is returned.
4. **Otherwise**, if the target value is less than the middle element, narrow the interval to the lower half.
5. **Else**, narrow it to the upper half.
6. **Repeat** the process until the target value is found or the interval is empty.

Binary Search operates in **O(log N)** time complexity, making it significantly faster than linear search for large datasets.

---

## Understanding Go Generics and `cmp.Ordered`

With the introduction of generics in Go 1.18, developers can write more flexible and reusable code. In our Binary Search implementations, we utilize generics to allow the search functions to operate on any ordered type.

### `cmp.Ordered` Constraint

The `cmp.Ordered` constraint is a type constraint that requires the type to support comparison operators (`<`, `<=`, `>`, `>=`). This ensures that the elements in the list can be ordered, which is a prerequisite for Binary Search.

By using generics with the `cmp.Ordered` constraint, our Binary Search functions can work with various data types such as integers, floating-point numbers, and strings, provided they are ordered.

---

## Iterative Binary Search Implementation

Let's explore the iterative implementation of Binary Search in Go.

### Iterative Binary Search Implementation Code Overview

```go
package algorithms

import (
	"cmp"
)

// BinarySearch performs an iterative binary search on a sorted list.
// It returns the index of the target if found, otherwise -1.
func BinarySearch[T cmp.Ordered](list []T, target T) int {
	firstIdx, lastIdx := 0, len(list)-1
	for firstIdx <= lastIdx {
		midIdx := (firstIdx + lastIdx) / 2
		midValue := list[midIdx]
		if midValue > target {
			lastIdx = midIdx - 1
		} else if midValue < target {
			firstIdx = midIdx + 1
		} else {
			return midIdx
		}
	}
	return -1
}
```

### Iterative Binary Search Implementation How It Works

1. **Initialization**:
    - `firstIdx`: The starting index of the search interval (initially `0`).
    - `lastIdx`: The ending index of the search interval (initially `len(list) - 1`).

2. **Loop Condition**:
    - The loop continues as long as `firstIdx` is less than or equal to `lastIdx`. This ensures that there is still a valid interval to search within.

3. **Calculating the Middle Index**:
    - `midIdx`: The middle index of the current search interval, calculated as `(firstIdx + lastIdx) / 2`.
    - `midValue`: The value at `midIdx` in the list.

4. **Comparison**:
    - If `midValue` is greater than the `target`, the search interval is narrowed to the lower half by setting `lastIdx` to `midIdx - 1`.
    - If `midValue` is less than the `target`, the search interval is narrowed to the upper half by setting `firstIdx` to `midIdx + 1`.
    - If `midValue` equals the `target`, the function returns `midIdx`, indicating the position of the target.

5. **Termination**:
    - If the loop completes without finding the `target`, the function returns `-1`, indicating that the target is not present in the list.

### Iterative Binary Search Implementation Example Walkthrough

Consider searching for the target value `7` in the sorted list `[1, 3, 5, 7, 9, 11]`.

1. **Initial State**:
    - `firstIdx = 0`
    - `lastIdx = 5`

2. **First Iteration**:
    - `midIdx = (0 + 5) / 2 = 2`
    - `midValue = list[2] = 5`
    - Since `5 < 7`, update `firstIdx` to `3`.

3. **Second Iteration**:
    - `midIdx = (3 + 5) / 2 = 4`
    - `midValue = list[4] = 9`
    - Since `9 > 7`, update `lastIdx` to `3`.

4. **Third Iteration**:
    - `midIdx = (3 + 3) / 2 = 3`
    - `midValue = list[3] = 7`
    - `7 == 7`, target found at index `3`.

### Iterative Binary Search Implementation Time and Space Complexity

- **Time Complexity**: **O(log N)**
    - The search interval is halved with each iteration, leading to logarithmic time complexity.

- **Space Complexity**: **O(1)**
    - The iterative approach uses a constant amount of extra space.

---

## Recursive Binary Search Implementation

Now, let's examine the recursive implementation of Binary Search in Go.

### Recursive Binary Search Implementation Code Overview

```go
package algorithms

import (
	"cmp"
)

// RecursiveBinarySearch performs a recursive binary search on a sorted list.
// It returns the index of the target if found, otherwise -1.
func RecursiveBinarySearch[T cmp.Ordered](list []T, target T, firstIdx, lastIdx int) int {
	if firstIdx > lastIdx {
		return -1
	}
	midIdx := (firstIdx + lastIdx) / 2
	midValue := list[midIdx]
	if target == midValue {
		return midIdx
	} else {
		if target < midValue {
			return RecursiveBinarySearch[T](list, target, firstIdx, midIdx-1)
		} else {
			return RecursiveBinarySearch[T](list, target, midIdx+1, lastIdx)
		}
	}
}
```

### Recursive Binary Search Implementation How It Works

1. **Base Case**:
    - If `firstIdx` exceeds `lastIdx`, the search interval is invalid, and the function returns `-1`, indicating that the target is not found.

2. **Calculating the Middle Index**:
    - `midIdx`: The middle index of the current search interval, calculated as `(firstIdx + lastIdx) / 2`.
    - `midValue`: The value at `midIdx` in the list.

3. **Comparison**:
    - If `midValue` equals the `target`, the function returns `midIdx`, indicating the position of the target.
    - If `target` is less than `midValue`, the function recursively searches the lower half by calling itself with updated indices (`firstIdx` to `midIdx - 1`).
    - If `target` is greater than `midValue`, the function recursively searches the upper half by calling itself with updated indices (`midIdx + 1` to `lastIdx`).

4. **Termination**:
    - The recursion continues until the base case is met or the target is found.

### Recursive Binary Search Implementation Example Walkthrough

Consider searching for the target value `7` in the sorted list `[1, 3, 5, 7, 9, 11]` using `RecursiveBinarySearch(list, 7, 0, 5)`.

1. **First Call**:
    - `firstIdx = 0`, `lastIdx = 5`
    - `midIdx = (0 + 5) / 2 = 2`
    - `midValue = list[2] = 5`
    - Since `7 > 5`, recurse with `firstIdx = 3`, `lastIdx = 5`.

2. **Second Call**:
    - `firstIdx = 3`, `lastIdx = 5`
    - `midIdx = (3 + 5) / 2 = 4`
    - `midValue = list[4] = 9`
    - Since `7 < 9`, recurse with `firstIdx = 3`, `lastIdx = 3`.

3. **Third Call**:
    - `firstIdx = 3`, `lastIdx = 3`
    - `midIdx = (3 + 3) / 2 = 3`
    - `midValue = list[3] = 7`
    - `7 == 7`, target found at index `3`.

### Recursive Binary Search Implementation Time and Space Complexity

- **Time Complexity**: **O(log N)**
    - Similar to the iterative approach, the search interval is halved with each recursive call.

- **Space Complexity**: **O(log N)**
    - Due to recursion, the call stack can grow up to `log N` levels deep.

---

## Comparing Iterative and Recursive Approaches

| Aspect                      | Iterative Binary Search | Recursive Binary Search    |
|-----------------------------|-------------------------|----------------------------|
| **Time Complexity**         | O(log N)                | O(log N)                   |
| **Space Complexity**        | O(1)                    | O(log N)                   |
| **Ease of Implementation**  | Simple and straightforward | Slightly more complex due to recursion |
| **Performance**             | Slightly better due to no recursion overhead | Potentially slower due to recursive calls |
| **Readability**             | Clear and easy to follow | Elegant but can be harder to trace |
| **Stack Overflow Risk**     | None                    | Possible with very large datasets |

### Summary

- **Iterative Approach**:
    - **Pros**:
        - Uses constant space.
        - Generally faster due to lack of recursion overhead.
        - Simpler stack usage, eliminating the risk of stack overflow.
    - **Cons**:
        - Can be slightly less elegant compared to the recursive approach.

- **Recursive Approach**:
    - **Pros**:
        - More elegant and closer to the theoretical definition of Binary Search.
        - Easier to understand for those familiar with recursion.
    - **Cons**:
        - Uses additional space proportional to the depth of recursion.
        - Risk of stack overflow with very large datasets.
        - Slightly slower due to the overhead of recursive calls.

---

## Conclusion

Binary Search is a powerful algorithm for efficiently searching through sorted datasets. Both iterative and recursive implementations in Go offer the same logarithmic time complexity, but they differ in space usage and implementation nuances.

- **Iterative Binary Search** is generally preferred in practice due to its constant space usage and slight performance advantages. It's straightforward to implement and free from the risks associated with deep recursion.

- **Recursive Binary Search** provides a more elegant and theoretically appealing solution, closely mirroring the mathematical definition of the algorithm. However, it comes with increased space usage and potential stack overflow risks for extremely large datasets.

By leveraging Go's generics and the `cmp.Ordered` constraint, these Binary Search implementations become versatile and reusable across various data types, enhancing code flexibility and maintainability.

Whether you choose an iterative or recursive approach depends on the specific requirements and constraints of your project. Understanding both methods equips you with the knowledge to make informed decisions and implement efficient search algorithms in your Go applications.