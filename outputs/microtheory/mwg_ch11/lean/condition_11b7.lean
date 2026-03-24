import Mathlib
open Topology

/-- Condition 11.B.7: KKT conditions for Consumer 2's optimization
    Max_{h₂ ≥ 0} φ₂(h₂) + p_h · h₂.
    At optimum: φ₂'(h₂) ≤ -p_h, with equality if h₂ > 0. -/
theorem Condition_11B7
    (φ₂' : ℝ → ℝ) (p_h h₂ : ℝ)
    (h_nonneg : h₂ ≥ 0)
    (h_foc_ineq : φ₂' h₂ + p_h ≤ 0)
    (h_compl_slack : h₂ > 0 → φ₂' h₂ + p_h = 0) :
    φ₂' h₂ ≤ -p_h ∧ (h₂ > 0 → φ₂' h₂ = -p_h) := by
  constructor
  · linarith
  · intro hpos
    linarith [h_compl_slack hpos]