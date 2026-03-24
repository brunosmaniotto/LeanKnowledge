# Category Supplement: Order Theory & Lattices

## Key imports
```lean
import Mathlib
open Lattice
```

## Core types
```
-- Partial orders
PartialOrder α          — partial order typeclass
LinearOrder α           — total/linear order
Preorder α              — preorder (reflexive, transitive)

-- Lattices
Lattice α               — lattice (sup and inf)
CompleteLattice α       — complete lattice (arbitrary sup/inf)
BooleanAlgebra α        — Boolean algebra
Sup, Inf, sSup, sInf    — supremum/infimum operations

-- Ordered algebraic structures
OrderedAddCommMonoid, OrderedSemiring, OrderedField
```

## Key lemmas
```
-- Basic order
le_refl         : a ≤ a
le_trans         : a ≤ b → b ≤ c → a ≤ c
le_antisymm      : a ≤ b → b ≤ a → a = b
lt_iff_le_not_le : a < b ↔ a ≤ b ∧ ¬b ≤ a

-- Supremum and infimum
le_sup_left      : a ≤ a ⊔ b
le_sup_right     : b ≤ a ⊔ b
sup_le           : a ≤ c → b ≤ c → a ⊔ b ≤ c
inf_le_left      : a ⊓ b ≤ a
inf_le_right     : a ⊓ b ≤ b
le_inf           : c ≤ a → c ≤ b → c ≤ a ⊓ b

-- Min and max (for LinearOrder)
min_comm, max_comm, min_assoc, max_assoc
min_le_left, min_le_right, le_max_left, le_max_right

-- Monotone functions
Monotone         : (a ≤ b → f a ≤ f b)
StrictMono       : (a < b → f a < f b)
Monotone.comp    : composition preserves monotonicity
```

## Common pitfalls
1. **`⊔` and `⊓`**: Lean 4 uses `⊔` for sup/join and `⊓` for inf/meet. NOT `∪`/`∩` (those are set operations).
2. **`Sup` vs `sSup`**: `sSup` takes a `Set`, while `iSup` takes a function. Use `iSup` for indexed suprema: `⨆ i, f i`.
3. **`omega` and `linarith`**: Both work well for linear order goals involving `≤`, `<`, `+`, `-`.
4. **Well-founded recursion**: For well-founded orders, use `WellFoundedRelation` or `IsWellFounded`.
