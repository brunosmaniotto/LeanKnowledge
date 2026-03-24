import Mathlib

/-
  Lemma 14.C.1: Constraint (ii) in problem (14.C.8) can be ignored.

  Setup:
  - w_H, w_L: wages for high/low types
  - g(e, θ): cost of effort e for type θ
  - θ_H > θ_L (higher type has lower cost: g(e, θ_H) ≤ g(e, θ_L))
  - v: utility function (strictly increasing)
  - v_inv: inverse of v
  - ū: reservation utility

  Constraints:
  (i)   w_H - g(e_H, θ_H) ≥ w_L - g(e_L, θ_H)   (IC for θ_H)
  (ii)  w_L - g(e_L, θ_L) ≥ w_H - g(e_H, θ_L)    (IC for θ_L)
  (iii) w_L - g(e_L, θ_L) ≥ v_inv(ū)              (IR for θ_L)

  We show (i) ∧ (iii) → (ii) is automatic when g(e_L, θ_H) ≤ g(e_L, θ_L).
  Actually, constraint (ii) as IR for θ_H: w_H - g(e_H, θ_H) ≥ v_inv(ū)
  follows from (i) and (iii) via the chain of inequalities.
-/

theorem Lemma_14C1
    (w_H w_L g_eH_θH g_eL_θH g_eL_θL v_inv_ubar : ℝ)
    -- Constraint (i): IC for θ_H type
    (h_ic_H : w_H - g_eH_θH ≥ w_L - g_eL_θH)
    -- Constraint (iii): IR for θ_L type
    (h_ir_L : w_L - g_eL_θL ≥ v_inv_ubar)
    -- Single-crossing: g_θ < 0 implies g(e_L, θ_H) ≤ g(e_L, θ_L)
    (h_sc : g_eL_θH ≤ g_eL_θL) :
    -- Constraint (ii): IR for θ_H type follows automatically
    w_H - g_eH_θH ≥ v_inv_ubar := by
  linarith