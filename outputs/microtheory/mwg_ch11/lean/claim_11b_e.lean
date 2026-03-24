import Mathlib
open Topology

theorem Claim_11B_e
    (φ₁ φ₂ : ℝ → ℝ)
    (φ₁' φ₂' : ℝ → ℝ)
    (h_opt : ℝ)
    (t_h : ℝ)
    (hh_opt_pos : h_opt > 0)
    -- t_h is the Pigouvian tax
    (h_tax_def : t_h = -φ₂' h_opt)
    -- t_h > 0 (negative externality)
    (h_tax_pos : t_h > 0)
    -- From Condition 11.B.2: at interior optimum, φ₁'(h°) = -φ₂'(h°)
    (h_pareto_foc : φ₁' h_opt = -φ₂' h_opt)
    -- φ₁ is strictly concave (deriv is strictly decreasing)
    (h_strict_concave : StrictAnti φ₁')
    -- φ₁' is the derivative of φ₁
    (hφ₁_deriv : ∀ x, HasDerivAt φ₁ (φ₁' x) x)
    -- Any h satisfying the FOC with tax t_h: φ₁'(h) = t_h (interior case)
    (h_candidate : ℝ)
    (h_cand_pos : h_candidate > 0)
    (h_cand_foc : φ₁' h_candidate = t_h)
    : h_candidate = h_opt := by
  -- From h_tax_def: t_h = -φ₂'(h°)
  -- From h_pareto_foc: φ₁'(h°) = -φ₂'(h°)
  -- So φ₁'(h°) = t_h
  have h_opt_foc : φ₁' h_opt = t_h := by rw [h_tax_def]; exact h_pareto_foc
  -- From h_cand_foc: φ₁'(h_candidate) = t_h = φ₁'(h_opt)
  -- Since φ₁' is strictly anti (strictly decreasing), it is injective
  exact h_strict_concave.injective (h_cand_foc.trans h_opt_foc.symm)