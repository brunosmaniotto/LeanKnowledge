import Mathlib
open Filter
open Topology

axiom closed_form_ramsey (k₀ : ℝ) (k : ℕ → ℝ)
    (hk0 : k 0 = k₀) (hrec : ∀ n, k (n + 2) = 3 * k (n + 1) - 2 * k n) :
    ∀ n, k n = k₀ + (k 1 - k₀) * ((2 : ℝ) ^ n - 1)

theorem Example_20D4 (k₀ : ℝ) (k : ℕ → ℝ)
    (hk0 : k 0 = k₀) (hrec : ∀ n, k (n + 2) = 3 * k (n + 1) - 2 * k n)
    (hbdd : ∃ M : ℝ, ∀ n, |k n| ≤ M) : k 1 = k₀ := by
  have closed := closed_form_ramsey k₀ k hk0 hrec
  by_contra h
  obtain ⟨M, hM⟩ := hbdd
  have hne : k 1 - k₀ ≠ 0 := sub_ne_zero.mpr h
  have hdpos : (0 : ℝ) < |k 1 - k₀| := abs_pos.mpr hne
  have hgrow := tendsto_pow_atTop_atTop_of_one_lt (show (1:ℝ) < 2 by norm_num)
  rw [tendsto_atTop_atTop] at hgrow
  obtain ⟨N, hN⟩ := hgrow ((M + |k₀|) / |k 1 - k₀| + 2)
  specialize hN N le_rfl
  have hmul : M + |k₀| + 2 * |k 1 - k₀| ≤ |k 1 - k₀| * (2:ℝ)^N := by
    have hstep := mul_le_mul_of_nonneg_right hN (le_of_lt hdpos)
    have hexp : ((M + |k₀|) / |k 1 - k₀| + 2) * |k 1 - k₀|
        = (M + |k₀|) / |k 1 - k₀| * |k 1 - k₀| + 2 * |k 1 - k₀| := by ring
    have hdiv : (M + |k₀|) / |k 1 - k₀| * |k 1 - k₀| = M + |k₀| := by
      field_simp [hdpos.ne']
    rw [hexp, hdiv] at hstep
    linarith [mul_comm ((2:ℝ)^N) |k 1 - k₀|]
  have hbig : M + |k₀| < |k 1 - k₀| * ((2:ℝ)^N - 1) := by
    have : |k 1 - k₀| * ((2:ℝ)^N - 1) = |k 1 - k₀| * (2:ℝ)^N - |k 1 - k₀| := by ring
    linarith
  have hkN := hM N
  rw [closed N] at hkN
  rw [abs_le] at hkN
  rcases le_or_gt (k 1 - k₀) 0 with hneg | hposd
  · rw [abs_of_neg (lt_of_le_of_ne hneg hne)] at hbig
    nlinarith [le_abs_self k₀, hkN.1]
  · rw [abs_of_pos hposd] at hbig
    nlinarith [neg_abs_le k₀, hkN.2]