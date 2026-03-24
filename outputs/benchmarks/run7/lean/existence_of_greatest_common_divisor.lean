import Mathlib

theorem existence_of_gcd (a b : ℤ) (h_nonzero : a ≠ 0 ∨ b ≠ 0) :
    ∃ g : ℤ, (g ∣ a ∧ g ∣ b) ∧ ∀ d : ℤ, (d ∣ a ∧ d ∣ b) → d ≤ g := by
  let S : Set ℤ := {d | d ∣ a ∧ d ∣ b}
  have hS_nonempty : S.Nonempty := by
    refine ⟨1, ?_⟩
    exact ⟨by simp, by simp⟩
  have hS_bdd : ∃ n, ∀ m ∈ S, m ≤ n := by
    rcases h_nonzero with (ha | hb)
    · refine ⟨|a|, fun d hd => ?_⟩
      have hd1 : d ∣ a := hd.1
      have h_abs : d ∣ |a| := by
        by_cases h : 0 ≤ a
        · rw [abs_of_nonneg h]
          exact hd1
        · rw [abs_of_nonpos (by linarith)]
          exact Int.dvd_neg.mpr hd1
      exact Int.le_of_dvd (abs_pos.mpr ha) h_abs
    · refine ⟨|b|, fun d hd => ?_⟩
      have hd2 : d ∣ b := hd.2
      have h_abs : d ∣ |b| := by
        by_cases h : 0 ≤ b
        · rw [abs_of_nonneg h]
          exact hd2
        · rw [abs_of_nonpos (by linarith)]
          exact Int.dvd_neg.mpr hd2
      exact Int.le_of_dvd (abs_pos.mpr hb) h_abs
  obtain ⟨g, hg, hg'⟩ := Int.exists_greatest_of_bdd hS_bdd hS_nonempty
  refine ⟨g, hg, ?_⟩
  intro d hd
  exact hg' d ⟨hd.1, hd.2⟩