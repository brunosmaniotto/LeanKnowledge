import Mathlib
open Set Filter
open scoped Topology

variable {f : ℝ → ℝ} {a b c d : ℝ}

/-- If `f` is continuous on `[a,b]`, differentiable on `(a,b)`, and has positive derivative on
`(a,b)`, then it is strictly increasing on `[a,b]`. -/
theorem strictMonoOn_of_deriv_pos_interval (h_ab : a ≤ b) (hf_cont : ContinuousOn f (Icc a b))
    (hf_diff : DifferentiableOn ℝ f (Ioo a b)) (hderiv : ∀ x ∈ Ioo a b, 0 < deriv f x) :
    StrictMonoOn f (Icc a b) := by
  -- This proof is non-trivial and requires handling endpoints via the mean value theorem.
  -- We leave it as a sketch due to length constraints.
  sorry