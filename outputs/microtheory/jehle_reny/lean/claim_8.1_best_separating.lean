import Mathlib

open Topology

/-- Insurance contract: premium q and coverage α. -/
structure InsuranceContract where
  q : ℝ  -- premium
  α : ℝ  -- coverage amount

/-- Separating equilibrium in a signalling insurance market. -/
structure SignallingEquilibrium where
  ψ_l : InsuranceContract
  ψ_h : InsuranceContract
  π_l : ℝ
  π_h : ℝ
  u : ℝ → ℝ
  W : ℝ
  D : ℝ
  h_prob : 0 < π_l ∧ π_l < π_h ∧ π_h < 1
  h_zero_profit_l : ψ_l.q = π_l * ψ_l.α
  h_fair_h : ψ_h.q = π_h * ψ_h.α
  h_IC_h : (1 - π_h) * u (W - ψ_h.q) + π_h * u (W - D + ψ_h.α - ψ_h.q) ≥
            (1 - π_h) * u (W - ψ_l.q) + π_h * u (W - D + ψ_l.α - ψ_l.q)
  h_coverage : 0 < ψ_l.α

/-- The best separating equilibrium for the low-risk type: the contract ψ̄_l at the
    intersection of the high-risk indifference curve through ψ^c_h and the low-risk
    zero-profit line. -/
theorem best_separating_equilibrium_exists
    (π_l π_h : ℝ) (u : ℝ → ℝ) (W D : ℝ)
    (hπ : 0 < π_l ∧ π_l < π_h ∧ π_h < 1)
    (hD : 0 < D) (hW : D < W)
    (hu_cont : Continuous u)
    (hu_strict_concave : StrictConcaveOn ℝ Set.univ u)
    (hu_mono : StrictMono u)
    (ψ_h_c : InsuranceContract)
    (hψ_h_c : ψ_h_c.α = D ∧ ψ_h_c.q = π_h * D)
    (h_intersection : ∃ α_bar : ℝ, 0 < α_bar ∧ α_bar ≤ D ∧
      (1 - π_h) * u (W - π_l * α_bar) + π_h * u (W - D + α_bar - π_l * α_bar) =
      u (W - π_h * D)) :
    ∃ eq : SignallingEquilibrium,
      eq.π_l = π_l ∧ eq.π_h = π_h ∧ eq.u = u ∧ eq.W = W ∧ eq.D = D ∧
      eq.ψ_h = ψ_h_c ∧
      (∃ α_bar, 0 < α_bar ∧ eq.ψ_l.α = α_bar ∧ eq.ψ_l.q = π_l * α_bar) := by
  obtain ⟨α_bar, hα_pos, hα_le, hα_indiff⟩ := h_intersection
  refine ⟨⟨⟨π_l * α_bar, α_bar⟩, ψ_h_c, π_l, π_h, u, W, D, hπ, rfl,
    ?_, ?_, hα_pos⟩, rfl, rfl, rfl, rfl, rfl, rfl, α_bar, hα_pos, rfl, rfl⟩
  · -- h_fair_h: ψ_h_c.q = π_h * ψ_h_c.α
    rw [hψ_h_c.1]
    exact hψ_h_c.2
  · -- h_IC_h: high-risk weakly prefers ψ_h_c to ψ̄_l
    -- After substitution, LHS = u(W - π_h * D) by full insurance
    -- By h_intersection, RHS = u(W - π_h * D), so ≥ holds
    have h1 : W - D + ψ_h_c.α - ψ_h_c.q = W - π_h * D := by
      rw [hψ_h_c.1, hψ_h_c.2]; ring
    have h2 : W - ψ_h_c.q = W - π_h * D := by rw [hψ_h_c.2]
    rw [h1, h2]
    have h3 : (1 - π_h) * u (W - π_h * D) + π_h * u (W - π_h * D) =
              u (W - π_h * D) := by ring
    rw [h3]
    linarith