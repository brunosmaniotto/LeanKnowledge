import Mathlib

/-- A production path (trajectory/program) is a sequence where every element
    belongs to the production set Y ⊂ ℝ^(2L). -/
def IsProductionPath (L : ℕ) (Y : Set (Fin (2 * L) → ℝ)) (y : ℕ → Fin (2 * L) → ℝ) : Prop :=
  ∀ t : ℕ, y t ∈ Y