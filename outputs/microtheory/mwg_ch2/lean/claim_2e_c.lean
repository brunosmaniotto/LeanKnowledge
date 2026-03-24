import Mathlib

open BigOperators Finset

theorem elasticity_homogeneity_condition
    {L : ℕ}
    (p : Fin L → ℝ)
    (w : ℝ)
    (x_l : ℝ)
    (hx : x_l ≠ 0)
    (dpdk : Fin L → ℝ)
    (dw : ℝ)
    (euler : ∑ k ∈ Finset.univ, dpdk k * p k + dw * w = 0)
    : ∑ k ∈ Finset.univ, (dpdk k * p k / x_l) + dw * w / x_l = 0 := by
  have : (∑ k ∈ Finset.univ, dpdk k * p k + dw * w) / x_l = 0 := by
    rw [euler]; simp
  rw [add_div, Finset.sum_div] at this
  exact this