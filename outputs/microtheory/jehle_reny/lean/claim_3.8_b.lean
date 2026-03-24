import Mathlib
open Topology

noncomputable section

/-- Input demands are decreasing in own price: ∂x_i/∂w_i = −∂²π/∂w_i² ≤ 0
    since by Hotelling's lemma x_i = −∂π/∂w_i, and π is convex so ∂²π/∂w_i² ≥ 0. -/
theorem Claim_3_8_b
    (π : ℝ → ℝ) (w : ℝ)
    (hd : DifferentiableAt ℝ (deriv π) w)
    (hconv : 0 ≤ deriv (deriv π) w) :
    deriv (fun t => -deriv π t) w ≤ 0 := by
  have h : HasDerivAt (fun t => -deriv π t) (-deriv (deriv π) w) w :=
    hd.hasDerivAt.neg
  linarith [h.deriv]