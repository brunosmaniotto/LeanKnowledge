import Mathlib

theorem Exercise_4_7_c
    (a b : ℝ) (ha : a > 0) (hb : b > 0)
    (c : ℝ → ℝ) (hc : ∀ q, c q = a * q + b * q ^ 2)
    (AC : ℝ → ℝ) (hAC : ∀ q, q > 0 → AC q = c q / q)
    : (∀ q, q > 0 → AC q = a + b * q) ∧
      (∀ q, q > 0 → AC q > a) ∧
      (∀ q, q > 0 → a + 2 * b * q > AC q) := by
  have hAC' : ∀ q : ℝ, q > 0 → AC q = a + b * q := by
    intro q hq
    rw [hAC q hq, hc q, div_eq_iff (ne_of_gt hq)]
    ring
  exact ⟨hAC',
    fun q hq => by rw [hAC' q hq]; linarith [mul_pos hb hq],
    fun q hq => by rw [hAC' q hq]; linarith [mul_pos hb hq]⟩