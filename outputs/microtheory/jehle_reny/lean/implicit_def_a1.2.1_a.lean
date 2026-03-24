import Mathlib

/-- A set is any collection of elements. In Lean 4 / Mathlib, this is
    `Set α := α → Prop`, with membership `x ∈ S` meaning `S x`.
    Sets can be defined by enumeration (e.g., `{2, 4, 6, 8}`) or by
    description (e.g., `{x | P x}`). -/
abbrev MWG.SetOf (α : Type*) := Set α