import Mathlib

open Matrix Finset BigOperators

/-- An input-output matrix A is **productive** if there exists some production plan α > 0
    such that (I − A)α ≥ 0, i.e., positive net output is achievable. -/
def Matrix.IsProductive {L : ℕ} (A : Matrix (Fin L) (Fin L) ℝ) : Prop :=
  ∃ α : Fin L → ℝ, (∀ i, 0 < α i) ∧ ∀ i, 0 ≤ ((1 - A) *ᵥ α) i