import Mathlib
open Topology

variable {n : ℕ}

/-- A preference relation on ℝⁿ (weak preference: x ≿ y) -/
def StronglyMonotone (pref : (Fin n → ℝ) → (Fin n → ℝ) → Prop) : Prop :=
  ∀ x y : Fin n → ℝ, (∀ i, x i ≤ y i) → x ≠ y → pref y x