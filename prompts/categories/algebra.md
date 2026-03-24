# Category Supplement: Algebra

## Key imports
```lean
import Mathlib
open Polynomial BigOperators Finset
```

## Core types
```
-- Abstract algebra
Group α, CommGroup α, Ring α, CommRing α, Field α
Subgroup G, Ideal R, RingHom R S, AlgHom R A B
MonoidHom, MulEquiv, RingEquiv

-- Polynomials
Polynomial R       — polynomials over ring R
Polynomial.eval    — evaluate polynomial at a point
Polynomial.degree  — degree of polynomial

-- Finite sums and products
Finset.sum, Finset.prod
```

## Key lemmas for sums and products
```
Finset.sum_range_succ  : ∑ i ∈ range (n+1), f i = (∑ i ∈ range n, f i) + f n
Finset.sum_range_zero  : ∑ i ∈ range 0, f i = 0
Finset.prod_range_succ : ∏ i ∈ range (n+1), f i = (∏ i ∈ range n, f i) * f n
Finset.sum_comm        : swap double summation
Finset.sum_add_sum     : sum of sums
Finset.sum_congr       : change summand when terms are equal
```

## Key lemmas for algebraic identities
```
pow_succ   : a ^ (n + 1) = a ^ n * a
pow_zero   : a ^ 0 = 1
mul_comm   : a * b = b * a
add_comm   : a + b = b + a
mul_assoc  : a * b * c = a * (b * c)
add_assoc  : a + b + c = a + (b + c)
mul_add    : a * (b + c) = a * b + a * c
add_mul    : (a + b) * c = a * c + b * c
sub_eq_add_neg : a - b = a + (-b)
neg_mul    : -(a * b) = -a * b
mul_neg    : a * (-b) = -(a * b)
```

## Induction patterns
```lean
-- Natural number induction
induction n with
| zero => ...
| succ n ih => ...

-- Strong induction
induction n using Nat.strong_rec_on with ...

-- Finset induction
induction s using Finset.induction with
| empty => ...
| insert ha hs ih => ...
```

## Common patterns
1. **Inductive sum proofs**: Rewrite goal with `Finset.sum_range_succ`, apply inductive hypothesis, then `ring` or `linarith`.
2. **Algebraic identities**: `ring` tactic closes most pure ring identities automatically.
3. **Polynomial proofs**: Use `Polynomial.eval_*` lemmas to reduce evaluation, then `ring`.
4. **Group theory**: `group` tactic for basic group equations; `mul_left_cancel`, `mul_right_cancel` for cancellation.

## Common pitfalls
1. **`Finset.range n` is `{0, 1, ..., n-1}`**, NOT `{1, ..., n}`. For `{1, ..., n}`, use `Finset.Icc 1 n`.
2. **Summation notation**: `∑ i ∈ Finset.range n, f i` (with `open BigOperators`), NOT `∑ i in range n, f i`.
3. **Don't forget `open BigOperators`** for `∑` and `∏` notation.

## Worked example: Sum of first n naturals
```lean
import Mathlib
open BigOperators Finset

theorem sum_range_id (n : ℕ) :
    2 * ∑ i ∈ range n, i = n * (n - 1) := by
  induction n with
  | zero => simp
  | succ n ih => rw [sum_range_succ]; omega
```
