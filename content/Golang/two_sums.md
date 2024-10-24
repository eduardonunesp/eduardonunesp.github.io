+++
title = "Understanding the Two Sum Problem in Go"
slug = "understanding-two-sum-problem-in-go"
date = "2024-05-13"
+++

# Understanding the Two Sum Problem in Go: Optimized and Brute Force Solutions

The **Two Sum** problem is a staple in algorithmic challenges, often used to assess a programmer's problem-solving skills and understanding of data structures. This article explores two Go (Golang) implementations of the Two Sum problem: an optimized approach using a hash map and a straightforward brute-force method. We'll delve into the problem statement, dissect both solutions, and analyze their time and space complexities.

---

## Table of Contents

1. [Problem Statement](#problem-statement)
2. [Solution 1: Optimized Approach Using a Hash Map](#solution-1-optimized-approach-using-a-hash-map)
    - [Solution 1 Code Overview](#solution-1-code-overview)
    - [Solution 1 How It Works](#solution-1-how-it-works)
    - [Solution 1 Example Walkthrough](#solution-1-example-walkthrough)
    - [Solution 1 Time and Space Complexity](#solution-1-time-and-space-complexity)
3. [Solution 2: Brute Force Approach Using Nested Loops](#solution-2-brute-force-approach-using-nested-loops)
    - [Solution 2 Code Overview](#solution-2-code-overview)
    - [Solution 2 How It Works](#solution-2-how-it-works)
    - [Solution 2 Example Walkthrough](#solution-2-example-walkthrough)
    - [Solution 2 Time and Space Complexity](#solution-2-time-and-space-complexity)
4. [Comparing the Two Approaches](#comparing-the-two-approaches)
5. [Conclusion](#conclusion)

---

## Problem Statement

**Given**:
- An array of integers `nums`.
- An integer `target`.

**Objective**:
Return the indices of the two numbers in `nums` such that they add up to `target`.

**Constraints**:
- Each input will have exactly one solution.
- You may not use the same element twice.
- The answer can be returned in any order.

### Examples

1. **Example 1**:
    - **Input**: `nums = [2,7,11,15]`, `target = 9`
    - **Output**: `[0,1]`
    - **Explanation**: Because `nums[0] + nums[1] == 9`, we return `[0, 1]`.

2. **Example 2**:
    - **Input**: `nums = [3,2,3]`, `target = 6`
    - **Output**: `[0,2]`

3. **Example 3**:
    - **Input**: `nums = [3,3]`, `target = 6`
    - **Output**: `[0,1]`

---

## Solution 1: Optimized Approach Using a Hash Map

### Solution 1 Code Overview

```go
func twoSum(nums []int, target int) []int {
    // Create a map to store the difference and its index
    resultMap := make(map[int]int)
    for idx, num := range nums {
        // Calculate the desired complement
        desired := target - num
        // Check if the complement exists in the map
        if n, ok := resultMap[desired]; ok {
            // If found, return the pair of indices
            return []int{n, idx}
        }
        // Store the current number and its index in the map
        resultMap[num] = idx
    }
    return []int{}
}
```

### Solution 1 How It Works

1. **Initialization**:
    - A hash map `resultMap` is created to store numbers as keys and their corresponding indices as values.

2. **Iteration**:
    - Iterate through each element `num` in the `nums` array using its index `idx`.

3. **Complement Calculation**:
    - For each `num`, compute the `desired` complement that would add up to the `target` (`desired = target - num`).

4. **Hash Map Lookup**:
    - Check if the `desired` complement exists in `resultMap`.
    - If it does, it means we've previously encountered the number that pairs with the current `num` to reach the `target`. Return the indices of these two numbers.

5. **Map Population**:
    - If the `desired` complement is not found, store the current `num` and its index in `resultMap` for future reference.

6. **Return Statement**:
    - If no solution is found during iteration (which shouldn't happen as per the problem constraints), return an empty slice.

### Solution 1 Example Walkthrough

Let's consider **Example 1**:

- **Input**: `nums = [2,7,11,15]`, `target = 9`
- **Process**:
    1. **First Iteration (`idx=0`, `num=2`)**:
        - `desired = 9 - 2 = 7`
        - `7` is not in `resultMap`.
        - Store `2` with index `0` in `resultMap`: `{2: 0}`.

    2. **Second Iteration (`idx=1`, `num=7`)**:
        - `desired = 9 - 7 = 2`
        - `2` is in `resultMap` with index `0`.
        - Return `[0, 1]`.

### Solution 1 Time and Space Complexity

- **Time Complexity**: **O(N)**
    - The algorithm traverses the list containing `N` elements only once. Each look-up in the hash map costs **O(1)** time on average.

- **Space Complexity**: **O(N)**
    - In the worst case, we store all `N` elements in the hash map.

---

## Solution 2: Brute Force Approach Using Nested Loops

### Solution 2 Code Overview

```go
func twoSumsBruteForce(nums []int, target int) []int {
    // Iterate through each element for the first number
    for idx1 := 0; idx1 < len(nums); idx1++ {
        // Iterate through the remaining elements for the second number
        for idx2 := idx1 + 1; idx2 < len(nums); idx2++ {
            // Check if the pair sums up to the target
            if nums[idx1]+nums[idx2] == target {
                return []int{idx1, idx2}
            }
        }
    }
    return []int{}
}
```

### Solution 2 How It Works

1. **Outer Loop**:
    - Iterate through each element `nums[idx1]` in the array.

2. **Inner Loop**:
    - For each `nums[idx1]`, iterate through the subsequent elements `nums[idx2]` to find a pair that sums to the `target`.

3. **Pair Check**:
    - If a pair `nums[idx1] + nums[idx2]` equals the `target`, return their indices `[idx1, idx2]`.

4. **Return Statement**:
    - If no such pair is found after exhausting all possibilities (which, according to the problem constraints, should not occur), return an empty slice.

### Solution 2 Example Walkthrough

Using **Example 1**:

- **Input**: `nums = [2,7,11,15]`, `target = 9`
- **Process**:
    1. **First Iteration (`idx1=0`, `num=2`)**:
        - Compare with `idx2=1` (`num=7`): `2 + 7 = 9` → Match found.
        - Return `[0, 1]`.

### Solution 2 Time and Space Complexity

- **Time Complexity**: **O(N²)**
    - Two nested loops each potentially iterate through all `N` elements, leading to a quadratic time complexity.

- **Space Complexity**: **O(1)**
    - The algorithm uses a constant amount of extra space.

---

## Comparing the Two Approaches

| Aspect                     | Optimized (Hash Map) | Brute Force (Nested Loops) |
|----------------------------|----------------------|----------------------------|
| **Time Complexity**        | O(N)                 | O(N²)                      |
| **Space Complexity**       | O(N)                 | O(1)                       |
| **Ease of Implementation** | Moderate             | Simple                     |
| **Performance**            | Significantly faster for large inputs | Slower, especially with large datasets |

**Summary**:
- The **optimized approach** using a hash map offers a linear time solution, making it highly efficient for large datasets. However, it requires additional space proportional to the input size.
- The **brute-force method** is straightforward and easy to implement but suffers from poor performance with increasing input sizes due to its quadratic time complexity.

---

## Conclusion

The Two Sum problem is an excellent exercise to understand the balance between time and space complexities in algorithm design. By leveraging data structures like hash maps, we can optimize solutions to run efficiently even with large inputs. Conversely, grasping brute-force methods provides foundational knowledge that helps recognize when and how optimizations can be applied.

In Go, both methods are elegantly implemented, showcasing the language's strengths in handling maps and control structures. Whether you're preparing for coding interviews or enhancing your algorithmic skills, mastering both approaches to the Two Sum problem is invaluable.

---

**Happy Coding!**