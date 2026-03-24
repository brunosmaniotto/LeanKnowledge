import Mathlib

/-- The constraint set for an equality-constrained maximization problem.
    Given constraint functions g₁,...,gₘ and target values b₁,...,bₘ,
    the constraint set is {x ∈ ℝᴺ : gᵢ(x) = bᵢ for all i}. -/
def MWG.ConstraintSet {N M : ℕ} (g : Fin M → (Fin N → ℝ) → ℝ) (b : Fin M → ℝ) :
    Set (Fin N → ℝ) :=
  {x | ∀ m, g m x = b m}