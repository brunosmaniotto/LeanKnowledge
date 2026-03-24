# Category Supplement: Set Theory

## Key imports
```lean
import Mathlib
open Set
```

## Core types
```
Set α      — sets (predicates on α), for general (possibly infinite) sets
Finset α   — finite sets, for counting and finite sums/products
Multiset α — finite multisets (bags with duplicates)
```

## Key lemmas for Set
```
-- Membership and basic operations
Set.mem_union         : x ∈ s ∪ t ↔ x ∈ s ∨ x ∈ t
Set.mem_inter_iff     : x ∈ s ∩ t ↔ x ∈ s ∧ x ∈ t
Set.mem_compl_iff     : x ∈ sᶜ ↔ x ∉ s
Set.mem_diff          : x ∈ s \ t ↔ x ∈ s ∧ x ∉ t
Set.mem_empty_iff_false : x ∈ (∅ : Set α) ↔ False
Set.mem_univ          : x ∈ (Set.univ : Set α)

-- Subset and equality
Set.subset_def        : s ⊆ t ↔ ∀ x, x ∈ s → x ∈ t
Set.ext_iff           : s = t ↔ ∀ x, x ∈ s ↔ x ∈ t
Set.Subset.antisymm   : s ⊆ t → t ⊆ s → s = t

-- Operations
Set.union_comm        : s ∪ t = t ∪ s
Set.inter_comm        : s ∩ t = t ∩ s
Set.union_assoc       : s ∪ t ∪ u = s ∪ (t ∪ u)
Set.inter_assoc       : s ∩ t ∩ u = s ∩ (t ∩ u)
Set.union_inter_distrib_left  : s ∪ (t ∩ u) = (s ∪ t) ∩ (s ∪ u)
Set.inter_union_distrib_left  : s ∩ (t ∪ u) = (s ∩ t) ∪ (s ∩ u)
Set.compl_union       : (s ∪ t)ᶜ = sᶜ ∩ tᶜ
Set.compl_inter       : (s ∩ t)ᶜ = sᶜ ∪ tᶜ
```

## Key lemmas for Finset
```
Finset.card_union_add_card_inter : (s ∪ t).card + (s ∩ t).card = s.card + t.card
Finset.card_empty     : (∅ : Finset α).card = 0
Finset.card_singleton : ({a} : Finset α).card = 1
Finset.subset_iff     : s ⊆ t ↔ ∀ x ∈ s, x ∈ t
```

## Power tactic pattern
Many set equality/subset goals can be closed with `ext` + `simp`:
```lean
-- Prove set equality
ext x; simp [Set.mem_union, Set.mem_inter_iff]

-- Prove subset
intro x hx; simp at hx ⊢; exact ...
```

## Common pitfalls
1. **`Set` vs `Finset`**: Use `Finset` for finite sets (when you need `.card`, sums, etc.). Use `Set` for general membership reasoning.
2. **`Set.ext`**: For proving `s = t`, use `ext x` to reduce to `x ∈ s ↔ x ∈ t`.
3. **Complement notation**: `sᶜ` is the complement. `s \ t` is set difference.
4. **`simp` with set lemmas**: `simp [Set.mem_union, Set.mem_inter_iff, Set.mem_compl_iff]` is very effective.
5. **De Morgan in sets**: `Set.compl_union` and `Set.compl_inter` are the set-theoretic De Morgan laws.

## Worked example: A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C)
```lean
import Mathlib
open Set

theorem inter_union_distrib {α : Type*} (A B C : Set α) :
    A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C) := by
  ext x
  simp [mem_inter_iff, mem_union, and_or_left]
```
