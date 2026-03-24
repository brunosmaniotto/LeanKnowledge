import Mathlib
open Topology

theorem Claim_11B_b (φ₁ φ₂ : ℝ → ℝ)
  (h_diff₁ : Differentiable ℝ φ₁)
  (h_diff₂ : Differentiable ℝ φ₂)
  (h_φ₁_deriv_strict_decreasing : StrictAnti (deriv φ₁))
  (h_star h_circ : ℝ)
  (h_h_star : (deriv φ₁) h_star = 0)
  (h_h_circ : (deriv φ₁) h_circ = -(deriv φ₂) h_circ)
  (h_h_star_pos : h_star > 0) -- Interior solution assumption
  (h_h_circ_pos : h_circ > 0) : -- Interior solution assumption
  ((deriv φ₂) h_circ < 0 → h_star > h_circ) ∧
  ((deriv φ₂) h_circ > 0 → h_star < h_circ) :=
by
  constructor
  -- Case 1: Negative externality (φ₂'(h°) < 0 → h* > h°)
  intro h_neg_externality
  -- From the definition of h°, we have φ₁'(h°) = -φ₂'(h°).
  -- Given φ₂'(h°) < 0, it follows that -φ₂'(h°) > 0.
  have h_φ₁_deriv_h_circ_pos : (deriv φ₁) h_circ > 0 := by
    linarith [h_h_circ, h_neg_externality]

  -- We know φ₁'(h*) = 0 and we just showed φ₁'(h°) > 0.
  -- Therefore, φ₁'(h*) < φ₁'(h°).
  have h_compare_derivs : (deriv φ₁) h_star < (deriv φ₁) h_circ := by
    rw [h_h_star]
    exact h_φ₁_deriv_h_circ_pos

  -- Since the derivative of φ₁ is strictly decreasing (StrictAnti) and
  -- φ₁'(h*) < φ₁'(h°), it implies that h° < h*.
  exact (StrictAnti.lt_iff_gt h_φ₁_deriv_strict_decreasing).mp h_compare_derivs

  -- Case 2: Positive externality (φ₂'(h°) > 0 → h* < h°)
  intro h_pos_externality
  -- From the definition of h°, we have φ₁'(h°) = -φ₂'(h°).
  -- Given φ₂'(h°) > 0, it follows that -φ₂'(h°) < 0.
  have h_φ₁_deriv_h_circ_neg : (deriv φ₁) h_circ < 0 := by
    linarith [h_h_circ, h_pos_externality]

  -- We know φ₁'(h*) = 0 and we just showed φ₁'(h°) < 0.
  -- Therefore, φ₁'(h°) < φ₁'(h*).
  have h_compare_derivs : (deriv φ₁) h_circ < (deriv φ₁) h_star := by
    rw [h_h_star]
    exact h_φ₁_deriv_h_circ_neg

  -- Since the derivative of φ₁ is strictly decreasing (StrictAnti) and
  -- φ₁'(h°) < φ₁'(h*), it implies that h* < h°.
  exact (StrictAnti.lt_iff_gt h_φ₁_deriv_strict_decreasing).mp h_compare_derivs