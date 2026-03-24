import Mathlib

noncomputable section

/-- In Example 19.E.6: arbitrage bounds on q₂, option properties, and comparative statics on dispersion. -/
theorem claim_19E_d (a q₂ : ℝ) (ha : a > 0)
    (h_arb_lo : q₂ > 1 - a) (h_arb_hi : q₂ < 3 + a)
    (c : ℝ) :
    max ((3 + a) - c) 0 ≥ 0 ∧
    max ((1 - a) - c) 0 ≥ 0 ∧
    (∀ a' : ℝ, a' > a →
      max ((3 + a') - c) 0 ≥ max ((3 + a) - c) 0 ∧
      max ((1 - a') - c) 0 ≤ max ((1 - a) - c) 0) := by
  refine ⟨le_max_right _ _, le_max_right _ _, fun a' ha' => ⟨?_, ?_⟩⟩
  · exact max_le_max_right 0 (by linarith)
  · exact max_le_max_right 0 (by linarith)

end