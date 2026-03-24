import Mathlib

open MeasureTheory

theorem coin_toss_modeled_by_bernoulli (p : ℝ) (hp : 0 ≤ p) (hp' : p ≤ 1) :
    ∃ μ : Measure Bool, IsProbabilityMeasure μ ∧ μ {true} = ENNReal.ofReal p ∧ μ {false} = ENNReal.ofReal (1 - p) := by
  have h1p : 0 ≤ 1 - p := by linarith
  set μ := (ENNReal.ofReal p) • (Measure.dirac true) + (ENNReal.ofReal (1 - p)) • (Measure.dirac false) with hμ
  have hμ_univ : μ Set.univ = 1 := by
    rw [hμ, Measure.add_apply, Measure.smul_apply, Measure.smul_apply]
    simp [Measure.map_dirac]
    rw [← ENNReal.ofReal_add hp h1p]
    norm_num
  have h_true : μ {true} = ENNReal.ofReal p := by
    rw [hμ, Measure.add_apply, Measure.smul_apply, Measure.smul_apply]
    simp [Measure.dirac_apply, Set.mem_singleton_iff]
  have h_false : μ {false} = ENNReal.ofReal (1 - p) := by
    rw [hμ, Measure.add_apply, Measure.smul_apply, Measure.smul_apply]
    simp [Measure.dirac_apply, Set.mem_singleton_iff]
  refine ⟨μ, { measure_univ := hμ_univ }, h_true, h_false⟩