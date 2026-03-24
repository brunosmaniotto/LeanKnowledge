import Mathlib

theorem pareto_foc_ratio_conditions
    {I J L : Type*}
    (p : L → ℝ)
    (μ : I → ℝ)
    (Du : I → L → ℝ)
    (DF : J → L → ℝ)
    (hμ_pos : ∀ i, μ i > 0)
    (hp_pos : ∀ ℓ, p ℓ > 0)
    (hU : ∀ i ℓ, Du i ℓ = μ i * p ℓ)
    (hF : ∀ j ℓ, DF j ℓ = p ℓ) :
    (∀ i i' ℓ ℓ', Du i ℓ / Du i ℓ' = Du i' ℓ / Du i' ℓ') ∧
    (∀ j j' ℓ ℓ', DF j ℓ / DF j ℓ' = DF j' ℓ / DF j' ℓ') ∧
    (∀ i j ℓ ℓ', Du i ℓ / Du i ℓ' = DF j ℓ / DF j ℓ') := by
  refine ⟨fun i i' ℓ ℓ' => ?_, fun j j' ℓ ℓ' => ?_, fun i j ℓ ℓ' => ?_⟩
  · simp only [hU]
    have hμi : μ i ≠ 0 := ne_of_gt (hμ_pos i)
    have hμi' : μ i' ≠ 0 := ne_of_gt (hμ_pos i')
    have hpℓ' : p ℓ' ≠ 0 := ne_of_gt (hp_pos ℓ')
    field_simp
  · simp only [hF]
  · simp only [hU, hF]
    have hμi : μ i ≠ 0 := ne_of_gt (hμ_pos i)
    have hpℓ' : p ℓ' ≠ 0 := ne_of_gt (hp_pos ℓ')
    field_simp