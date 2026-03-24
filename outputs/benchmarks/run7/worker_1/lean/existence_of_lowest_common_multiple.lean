import Mathlib

open Set

theorem exists_lcm (a b : ℤ) (ha : a ≠ 0) (hb : b ≠ 0) :
    ∃ m : ℤ, 0 < m ∧ a ∣ m ∧ b ∣ m ∧ ∀ n : ℤ, 0 < n → a ∣ n → b ∣ n → m ≤ n := by
  let S : Set ℤ := {n | 0 < n ∧ a ∣ n ∧ b ∣ n}
  have hS_nonempty : S.Nonempty := by
    have hab_ne_zero : a * b ≠ 0 := mul_ne_zero ha hb
    have hab_pos : 0 < |a * b| := abs_pos.mpr hab_ne_zero
    have ha_abs : a ∣ |a * b| := by
      by_cases h : 0 ≤ a * b
      · rw [abs_of_nonneg h]
        exact dvd_mul_right a b
      · have h' : a * b < 0 := by linarith
        rw [abs_of_neg h']
        exact dvd_neg.2 (dvd_mul_right a b)
    have hb_abs : b ∣ |a * b| := by
      by_cases h : 0 ≤ a * b
      · rw [abs_of_nonneg h]
        exact dvd_mul_left b a
      · have h' : a * b < 0 := by linarith
        rw [abs_of_neg h']
        exact dvd_neg.2 (dvd_mul_left b a)
    exact ⟨|a * b|, hab_pos, ha_abs, hb_abs⟩
  have h_bdd : ∃ b, ∀ x ∈ S, b ≤ x := ⟨0, fun x hx => hx.1.le⟩
  obtain ⟨m, hm_mem, hm_least⟩ := Int.exists_least_of_bdd h_bdd hS_nonempty
  rcases hm_mem with ⟨hm_pos, ha_m, hb_m⟩
  refine ⟨m, hm_pos, ha_m, hb_m, fun n hn_pos han hbn => hm_least n ⟨hn_pos, han, hbn⟩⟩