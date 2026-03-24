import Mathlib
open Topology

noncomputable def x1Demand (a p₁ y : ℝ) : ℝ := a * y / p₁

noncomputable def x2Demand (a p₂ y : ℝ) : ℝ := (1 - a) * y / p₂

theorem Claim_1E_e (a : ℝ) (ha0 : 0 < a) (ha1 : a < 1)
    (p₁ p₂ y : ℝ) (hp₁ : 0 < p₁) (hp₂ : 0 < p₂) (hy : 0 < y) :
    (∀ p₁', 0 < p₁' → p₁ < p₁' → x1Demand a p₁' y < x1Demand a p₁ y) ∧
    (∀ p₂', 0 < p₂' → p₂ < p₂' → x2Demand a p₂' y < x2Demand a p₂ y) ∧
    (∀ y', y < y' → x1Demand a p₁ y < x1Demand a p₁ y') := by
  simp only [x1Demand, x2Demand]
  refine ⟨fun p₁' hp₁' hlt => ?_, fun p₂' hp₂' hlt => ?_, fun y' hlt => ?_⟩
  · have h1 : (0 : ℝ) < p₁ * p₁' := mul_pos hp₁ hp₁'
    rw [div_lt_div_iff₀ hp₁' hp₁]
    nlinarith [mul_pos ha0 hy]
  · have h1 : (0 : ℝ) < p₂ * p₂' := mul_pos hp₂ hp₂'
    rw [div_lt_div_iff₀ hp₂' hp₂]
    nlinarith [mul_pos (sub_pos.mpr ha1) hy]
  · rw [div_lt_div_iff₀ hp₁ hp₁]
    nlinarith [mul_pos ha0 hp₁]