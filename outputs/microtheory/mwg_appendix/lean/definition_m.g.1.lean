import Mathlib

namespace MWG

/-- Definition M.G.1: A set A ⊂ ℝ^N is convex if αx + (1 - α)x' ∈ A
    whenever x, x' ∈ A and α ∈ [0, 1]. -/
def IsConvexSet {N : ℕ} (A : Set (Fin N → ℝ)) : Prop :=
  ∀ x x' : Fin N → ℝ, x ∈ A → x' ∈ A →
    ∀ α : ℝ, 0 ≤ α → α ≤ 1 →
      (α • x + (1 - α) • x') ∈ A

end MWG