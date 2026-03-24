import Mathlib

-- Axiomatized sub-lemmas (use these as given facts)
axiom differentiable_on_implies_differentiable_at {f : ℝ → ℝ} {a b ξ : ℝ} (h_diff_on : DifferentiableOn ℝ f (Set.Ioo a b)) (h_xi_in_interval : ξ ∈ Set.Ioo a b) : DifferentiableAt ℝ f ξ
axiom local_extr_and_differentiable_implies_deriv_zero {f : ℝ → ℝ} {ξ : ℝ} (h_extr : IsLocalExtr f ξ) (h_diff_at : DifferentiableAt ℝ f ξ) : deriv f ξ = 0

-- Main theorem: Derivative at Maximum or Minimum
-- Let f be a real function which is differentiable on the open interval (a, b).
-- Let f have a local minimum or local maximum at ξ ∈ (a, b).
-- Then f'(ξ) = 0.
theorem derivative_at_maximum_or_minimum
    {f : ℝ → ℝ} {a b ξ : ℝ}
    (h_diff_on : DifferentiableOn ℝ f (Set.Ioo a b))
    (h_xi_in_interval : ξ ∈ Set.Ioo a b)
    (h_extr : IsLocalMin f ξ ∨ IsLocalMax f ξ) :
    deriv f ξ = 0 := by
  -- Step 1: Establish differentiability at the point ξ.
  -- The first axiom states that differentiability on an open interval implies
  -- differentiability at any point within that interval.
  have h_diff_at : DifferentiableAt ℝ f ξ :=
    differentiable_on_implies_differentiable_at h_diff_on h_xi_in_interval

  -- The hypothesis `h_extr` is the definition of `IsLocalExtr`.
  -- `IsLocalExtr f ξ` is defined as `IsLocalMin f ξ ∨ IsLocalMax f ξ`.
  -- We can use `h_extr` directly where a proof of `IsLocalExtr f ξ` is needed.
  -- For clarity, we can create an intermediate `have`.
  have h_is_extr : IsLocalExtr f ξ := h_extr

  -- Step 2: Apply the theorem for local extrema.
  -- The second axiom states that if a function has a local extremum at a point
  -- and is differentiable at that point, its derivative there is zero.
  exact local_extr_and_differentiable_implies_deriv_zero h_is_extr h_diff_at