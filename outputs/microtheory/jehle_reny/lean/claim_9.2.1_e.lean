import Mathlib
open Topology

theorem Claim_9_2_1_e :
    (∀ (v : ℝ) (N : ℕ), 0 < v → 2 ≤ N → v * ((↑N - 1) / ↑N) < v) ∧
    (∀ (N : ℕ), 2 ≤ N → (↑N - 1 : ℝ) / ↑N < ↑N / (↑N + 1)) := by
  constructor
  · intro v N hv hN
    have hNp : (0 : ℝ) < ↑N := by positivity
    have h : (↑N - 1 : ℝ) / ↑N < 1 := by rw [div_lt_one hNp]; linarith
    calc v * ((↑N - 1) / ↑N) < v * 1 := mul_lt_mul_of_pos_left h hv
      _ = v := mul_one v
  · intro N hN
    have hNp : (0 : ℝ) < ↑N := by positivity
    have hN1p : (0 : ℝ) < ↑N + 1 := by linarith
    have hNne : (↑N : ℝ) ≠ 0 := ne_of_gt hNp
    have hN1ne : (↑N : ℝ) + 1 ≠ 0 := ne_of_gt hN1p
    rw [div_lt_div_iff₀ hNp hN1p]
    nlinarith