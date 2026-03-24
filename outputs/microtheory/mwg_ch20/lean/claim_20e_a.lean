import Mathlib

theorem stationary_equilibrium_interest_rate
    (δ : ℝ) (hδ_pos : 0 < δ) (hδ_lt : δ < 1) :
    let r := (1 - δ) / δ
    (1 + r) * δ = 1 ∧ r = 1 / δ - 1 ∧ 0 < r := by
  refine ⟨?_, ?_, ?_⟩
  · field_simp
    linarith
  · field_simp
  · exact div_pos (by linarith) hδ_pos