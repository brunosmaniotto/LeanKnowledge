import Mathlib

theorem Square_Modulo_4 (x : ℤ) : (Even x → x ^ 2 % 4 = 0) ∧ (Odd x → x ^ 2 % 4 = 1) := by
  constructor
  · intro h_even
    obtain ⟨k, hk⟩ := h_even
    rw [hk]
    ring_nf
    simp
  · intro h_odd
    exact Int.sq_mod_four_eq_one_of_odd h_odd