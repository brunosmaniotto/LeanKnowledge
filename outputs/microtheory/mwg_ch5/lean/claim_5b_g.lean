import Mathlib
open Topology

/-- If a production function is homogeneous of degree 1 (all inputs accounted for),
    then it cannot exhibit decreasing returns. Decreasing returns imply a hidden input. -/
theorem Claim_5B_g
    {n : ℕ} (f : (Fin n → ℝ) → ℝ)
    (homog : ∀ (t : ℝ) (x : Fin n → ℝ), 0 < t → f (t • x) = t * f x)
    (t : ℝ) (ht : 1 < t) (x : Fin n → ℝ)
    : ¬ (f (t • x) < t * f x) := by
  rw [homog t x (by linarith)]
  exact lt_irrefl _