import Mathlib

open Set Filter Topology
open Filter
open Topology

noncomputable section

/-- The firm's supply q* solves Max_q (p·q − c(q)) and satisfies the FOC:
    p ≤ c'(q*), with equality if q* > 0. -/
theorem Condition_11C4
    (c : ℝ → ℝ) (p qstar : ℝ)
    (hq_nonneg : qstar ≥ 0)
    (hc_diff : DifferentiableAt ℝ c qstar)
    (h_max : ∀ q : ℝ, q ≥ 0 → p * q - c q ≤ p * qstar - c qstar) :
    p ≤ deriv c qstar ∧ (qstar > 0 → p = deriv c qstar) := by
  set π := fun q => p * q - c q with hπ_def
  have hπ_deriv : HasDerivAt π (p - deriv c qstar) qstar := by
    have hp : HasDerivAt (fun q => p * q) p qstar := by
      have := (hasDerivAt_id qstar).const_mul p
      simpa [mul_comm] using this
    exact hp.sub hc_diff.hasDerivAt
  constructor
  · -- p ≤ c'(q*): the right-slope of π at q* is ≤ 0
    suffices h : p - deriv c qstar ≤ 0 by linarith
    have htend : Tendsto (fun t => t⁻¹ • (π (qstar + t) - π qstar))
        (𝓝[>] (0 : ℝ)) (𝓝 (p - deriv c qstar)) :=
      hπ_deriv.tendsto_slope_zero_right
    apply le_of_tendsto htend
    filter_upwards [self_mem_nhdsWithin] with t (ht : 0 < t)
    simp only [smul_eq_mul]
    have hge : qstar + t ≥ 0 := by linarith
    have hle : π (qstar + t) ≤ π qstar := h_max (qstar + t) hge
    exact mul_nonpos_of_nonneg_of_nonpos (le_of_lt (inv_pos.mpr ht)) (by linarith)
  · -- q* > 0 → p = c'(q*): interior max ⟹ derivative = 0
    intro hq_pos
    have hlocal : IsLocalMax π qstar := by
      apply IsMaxOn.isLocalMax _ (Ici_mem_nhds hq_pos)
      intro x hx
      exact h_max x (mem_Ici.mp hx)
    have := hlocal.hasDerivAt_eq_zero hπ_deriv
    linarith