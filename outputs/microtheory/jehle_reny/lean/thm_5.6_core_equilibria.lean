import Mathlib

open Finset BigOperators

-- Define Bundle (consumption vector)
abbrev Bundle (L : ℕ) := Fin L → ℝ

-- Define Allocation (a bundle for each consumer)
abbrev Allocation (I : Type*) (L : ℕ) := I → Bundle L

-- Define Endowment (initial endowment for each consumer)
abbrev Endowment (I : Type*) (L : ℕ) := I → Bundle L

-- A utility function is strictly increasing
def IsStrictlyIncreasingUtility (L : ℕ) (u : Bundle L → ℝ) : Prop :=
  ∀ x y : Bundle L, (∀ l, y l ≤ x l) → x ≠ y → u y < u x

-- An allocation x is feasible given endowments e
-- All individual bundles must be non-negative and the aggregate equals total endowment