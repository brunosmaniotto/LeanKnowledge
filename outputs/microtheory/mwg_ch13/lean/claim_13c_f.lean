import Mathlib
open Topology

theorem pooling_equilibrium_pareto_dominance
    (θ_L θ_H lam : ℝ)
    (hθ : θ_L < θ_H)
    (hlam_pos : 0 < lam)
    (hlam_lt : lam < 1)
    (c : ℝ → ℝ → ℝ)
    (hc_zero : ∀ θ, c 0 θ = 0)
    (hc_mono_e : ∀ θ e₁ e₂, 0 ≤ e₁ → e₁ < e₂ → c e₁ θ < c e₂ θ)
    (e' : ℝ)
    (he'_pos : 0 ≤ e')
    (he'_def : lam * θ_H + (1 - lam) * θ_L - c e' θ_L = θ_L)
    (e_star : ℝ)
    (he_star_nn : 0 ≤ e_star)
    (he_star_le : e_star ≤ e') :
    (lam * θ_H + (1 - lam) * θ_L - c e_star θ_L ≤ lam * θ_H + (1 - lam) * θ_L) ∧
    (lam * θ_H + (1 - lam) * θ_L - c e_star θ_H ≤ lam * θ_H + (1 - lam) * θ_L) := by
  have cost_nn : ∀ θ, 0 ≤ c e_star θ := by
    intro θ
    rcases eq_or_lt_of_le he_star_nn with h | h
    · rw [← h, hc_zero]
    · exact le_of_lt (by rw [← hc_zero θ]; exact hc_mono_e θ 0 e_star le_rfl h)
  constructor <;> linarith [cost_nn θ_L, cost_nn θ_H]