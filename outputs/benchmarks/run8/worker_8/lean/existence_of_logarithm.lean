import Mathlib

theorem exists_unique_log (b : ℝ) (hb : b > 1) (y : ℝ) (hy : y > 0) : ∃! x : ℝ, b ^ x = y := by
  have hb0 : 0 < b := by linarith
  have hb1 : b ≠ 1 := by linarith
  refine ⟨Real.logb b y, Real.rpow_logb hb0 hb1 hy, ?_⟩
  intro x hx
  have H : b ^ x = b ^ (Real.logb b y) := by
    rw [hx, Real.rpow_logb hb0 hb1 hy]
  exact (Real.strictMono_rpow_of_base_gt_one hb).injective H