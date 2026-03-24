import Mathlib

open Real

theorem alphabeta_bne_cutoff (c : ℝ) (hc_pos : 0 < c) (hc_lt : c < 1) :
    let θ_star := c ^ (1/3 : ℝ)
    θ_star ^ 3 = c ∧ 0 < θ_star ∧ θ_star < 1 := by
  constructor
  · -- (c^(1/3))^3 = c
    show (c ^ (1/3 : ℝ)) ^ (3 : ℕ) = c
    rw [← rpow_natCast (c ^ (1/3 : ℝ)) 3]
    rw [← rpow_mul (le_of_lt hc_pos)]
    norm_num
  · constructor
    · -- 0 < c^(1/3)
      exact rpow_pos_of_pos hc_pos _
    · -- c^(1/3) < 1
      have h1 : c ^ (1/3 : ℝ) < 1 ^ (1/3 : ℝ) := by
        apply rpow_lt_rpow (le_of_lt hc_pos) hc_lt
        norm_num
      rwa [one_rpow] at h1