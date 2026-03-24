import Mathlib

theorem signaling_equilibrium_dominance
    (θ_L θ_H r : ℝ)
    (μ : ℝ)
    (h_order : θ_L < r)
    (h_order2 : r < θ_H)
    (h_mean_low : μ < r)
    (h_mean_def : ∃ p : ℝ, 0 < p ∧ p < 1 ∧ μ = p * θ_L + (1 - p) * θ_H)
    (c : ℝ → ℝ → ℝ)
    (hc_zero : ∀ θ, c 0 θ = 0)
    (hc_pos : ∀ e θ, 0 < e → 0 < c e θ)
    (h_single_crossing : ∀ e, 0 < e → c e θ_L > c e θ_H)
    (h_exists_e : ∃ ê : ℝ, 0 < ê ∧ θ_H - c ê θ_H > r) :
    (μ < r) ∧
    (∀ w_pool : ℝ, w_pool = μ → w_pool < r) ∧
    (θ_L < r ∧ r < θ_H) ∧
    (∃ ê : ℝ, 0 < ê ∧ θ_H - c ê θ_H > r ∧ c 0 θ_L = 0) := by
  refine ⟨h_mean_low, ?_, ⟨h_order, h_order2⟩, ?_⟩
  · intro w hw
    linarith
  · obtain ⟨ê, hê_pos, hê_gain⟩ := h_exists_e
    exact ⟨ê, hê_pos, hê_gain, hc_zero θ_L⟩