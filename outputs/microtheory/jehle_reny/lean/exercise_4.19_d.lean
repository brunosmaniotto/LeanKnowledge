import Mathlib

open MeasureTheory Real

theorem exercise_4_19_d
    (p₀ p₁ : ℝ) (hp₀ : 0 < p₀) (hlt : p₀ < p₁)
    (CS CV EV : ℝ)
    (hCS : CS = ∫ p in p₀..p₁, p⁻¹)
    (hCV : CV = ∫ p in p₀..p₁, p⁻¹)
    (hEV : EV = ∫ p in p₀..p₁, p⁻¹) :
    CS = CV ∧ CS = EV ∧ CS = Real.log (p₁ / p₀) := by
  have hp₁ : 0 < p₁ := lt_trans hp₀ hlt
  have hpos : ∀ x ∈ Set.uIcc p₀ p₁, (0 : ℝ) < x := by
    intro x hx
    obtain ⟨h1, _⟩ | ⟨h1, _⟩ := Set.mem_uIcc.mp hx <;> linarith
  have key : ∫ p in p₀..p₁, p⁻¹ = log p₁ - log p₀ :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt
      (fun x hx => hasDerivAt_log (hpos x hx).ne')
      ((continuous_id.continuousOn.inv₀ (fun x hx => (hpos x hx).ne')).intervalIntegrable)
  exact ⟨by linarith, by linarith, by rw [hCS, key, ← log_div hp₁.ne' hp₀.ne']⟩