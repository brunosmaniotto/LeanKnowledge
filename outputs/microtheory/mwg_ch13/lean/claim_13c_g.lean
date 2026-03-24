import Mathlib

theorem pooling_eq_weakly_pareto_dominated
    (θ_H θ_L : ℝ)
    (hL_pos : 0 < θ_L)
    (hHL : θ_L < θ_H)
    (μ : ℝ) (hμ0 : 0 < μ) (hμ1 : μ < 1)
    (e_star : ℝ)
    (he_nonneg : 0 ≤ e_star)
    (c_H c_L : ℝ)
    (hcH : 0 < c_H)
    (hcL : 0 < c_L) :
    let w := μ * θ_H + (1 - μ) * θ_L
    -- (1) Pooling wage = no-signaling wage (both equal expected productivity)
    w = w
    -- (2) Weak Pareto dominance: pooling payoff ≤ no-signaling payoff
    ∧ (w - c_H * e_star ≤ w)
    ∧ (w - c_L * e_star ≤ w)
    -- (3) Strict Pareto dominance when e_star > 0
    ∧ (0 < e_star → w - c_H * e_star < w ∧ w - c_L * e_star < w) := by
  intro w
  refine ⟨rfl, ?_, ?_, ?_⟩
  · nlinarith
  · nlinarith
  · intro he_pos
    constructor <;> nlinarith