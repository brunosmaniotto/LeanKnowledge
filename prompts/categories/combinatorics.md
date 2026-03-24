# Category Supplement: Combinatorics

## Key imports
```lean
import Mathlib
open Finset BigOperators Nat
```

## Core types
```
Finset α            — finite sets
Fintype α           — typeclass: α has finitely many elements
Nat.choose n k      — binomial coefficient C(n, k)
Nat.factorial n     — n!
Finset.card s       — cardinality of a finite set
Finset.powerset s   — powerset of a finite set
Equiv.Perm α        — permutations of α
```

## Key lemmas
```
-- Binomial coefficients
Nat.choose_succ_succ  : choose (n+1) (k+1) = choose n k + choose n (k+1)
Nat.choose_zero_right : choose n 0 = 1
Nat.choose_self       : choose n n = 1
Nat.choose_symm       : k ≤ n → choose n k = choose n (n - k)
Nat.sum_range_choose  : ∑ k ∈ range (n+1), choose n k = 2^n

-- Factorial
Nat.factorial_pos     : 0 < n !
Nat.factorial_succ    : (n + 1)! = (n + 1) * n !

-- Finset operations
Finset.card_union_add_card_inter : (s ∪ t).card + (s ∩ t).card = s.card + t.card
Finset.card_sdiff_add_card_inter : (s \ t).card + (s ∩ t).card = s.card (when t ⊆ s)
Finset.card_powerset  : (Finset.powerset s).card = 2 ^ s.card
Finset.card_filter    : card of filtered set
Finset.card_range     : (range n).card = n

-- Counting / Pigeonhole
Finset.exists_ne_map_eq_of_card_lt : pigeonhole principle
Fintype.card_le_of_injective      : injection gives card bound
Fintype.card_le_of_surjective     : surjection gives card bound
```

## Common patterns
```lean
-- Prove by counting both sides
calc s.card = ... := by ...
  _ = ... := by ring

-- Induction on Finset
induction s using Finset.induction with
| empty => simp
| insert ha hs ih => ...

-- Binomial theorem approach
-- Use Nat.add_pow or Commute.add_pow for (a + b)^n expansions
```

## Common pitfalls
1. **`Nat.choose` is in `ℕ`**: Results are natural numbers. For real-valued combinatorics, cast with `(↑(Nat.choose n k) : ℝ)`.
2. **`Finset.range n` = `{0, ..., n-1}`**: NOT `{1, ..., n}`. Use `Finset.Icc 1 n` for that.
3. **Decidable equality**: Many `Finset` operations need `[DecidableEq α]`. Add it as a typeclass.
4. **`Fintype` vs `Finset`**: `Fintype α` means the whole type is finite. `Finset α` is a finite subset. Use `Finset.univ` to get the universal `Finset` when `[Fintype α]`.
5. **Factorial with `open Nat`**: Write `n !` (with space) or `Nat.factorial n`.

## Worked example: Binomial coefficient symmetry
```lean
import Mathlib

theorem choose_symm_example (n k : ℕ) (h : k ≤ n) :
    Nat.choose n k = Nat.choose n (n - k) :=
  Nat.choose_symm h
```
