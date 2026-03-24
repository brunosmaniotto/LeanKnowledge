import Mathlib

theorem exercise_7_5_d :
    ∃ f : ℕ → ℕ, f 0 = 100 ∧ f 99 = 1 ∧
      (∀ k, k < 99 → f (k + 1) < f k) ∧
      (∀ k, k ≥ 99 → f k = 1) := by
  refine ⟨fun k => if k ≥ 99 then 1 else 100 - k, ?_, ?_, ?_, ?_⟩
  · norm_num
  · norm_num
  · intro k hk
    have h1 : ¬(k ≥ 99) := by omega
    by_cases h3 : k + 1 ≥ 99
    · simp only [if_neg h1, if_pos h3]; omega
    · simp only [if_neg h1, if_neg h3]; omega
  · intro k hk
    simp only [if_pos hk]