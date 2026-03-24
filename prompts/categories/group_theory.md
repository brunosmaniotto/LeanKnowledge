# Category Supplement: Group Theory

## Key imports
```lean
import Mathlib
open Subgroup MulAction
```

## Core types
```
Group G, CommGroup G      — group, abelian group
AddGroup A, AddCommGroup A — additive group notation
Subgroup G                — subgroup of G
QuotientGroup.Quotient N  — quotient group G / N
MonoidHom G H             — group homomorphism (also G →* H)
MulEquiv G H              — group isomorphism (also G ≃* H)
Equiv.Perm α              — symmetric group on α
MulAction G α             — group action of G on α
```

## Key lemmas
```
-- Group basics
mul_one, one_mul           : a * 1 = a, 1 * a = a
mul_inv_cancel             : a * a⁻¹ = 1
inv_mul_cancel             : a⁻¹ * a = 1
mul_assoc                  : a * b * c = a * (b * c)
mul_left_cancel            : a * b = a * c → b = c
mul_right_cancel           : b * a = c * a → b = c

-- Subgroups
Subgroup.mem_top           : x ∈ (⊤ : Subgroup G)
Subgroup.mem_bot           : x ∈ (⊥ : Subgroup G) ↔ x = 1
Subgroup.closure           : smallest subgroup containing a set

-- Homomorphisms
MonoidHom.map_mul          : f (a * b) = f a * f b
MonoidHom.map_one          : f 1 = 1
MonoidHom.map_inv          : f a⁻¹ = (f a)⁻¹
MonoidHom.ker              : kernel
MonoidHom.range            : image

-- Order and Lagrange
Subgroup.card_subgroup_dvd_card : subgroup order divides group order
orderOf_dvd_card           : order of element divides group order
```

## Common patterns
```lean
-- Prove group equation by cancellation
calc a * b * c = ...  by rw [mul_assoc]
  _ = ...              by rw [mul_inv_cancel]

-- Use `group` tactic for basic group identities
example (a b : G) [Group G] : a * b * b⁻¹ = a := by group

-- Subgroup membership
intro x hx
exact Subgroup.mul_mem _ hx ...
```

## Common pitfalls
1. **Multiplicative vs additive**: `Group` uses `*` and `1`. `AddGroup` uses `+` and `0`. Use the right notation.
2. **`group` tactic**: Closes basic group identities automatically. Try it before manual rewriting.
3. **`Subgroup` vs `Set`**: A `Subgroup G` is NOT a `Set G`. Use `↑H` or `(H : Set G)` to coerce.
4. **Quotient groups**: Need `N.Normal` (normal subgroup) to form `G ⧸ N`.
5. **`zpow`**: For integer powers in groups, use `a ^ (n : ℤ)` which calls `zpow`.
