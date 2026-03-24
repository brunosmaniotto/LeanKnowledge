import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- If a choice function satisfies WARP and budget balancedness,
    then it is homogeneous of degree zero in (p, y). -/
theorem Claim_2_3_c
    {n : ℕ}
    (p₀ x₀ x₁ : Fin n → ℝ)
    (y₀ : ℝ)
    (t : ℝ) (ht : t > 0)
    -- Budget balancedness: x₀ chosen at (p₀, y₀), x₁ chosen at (t·p₀, t·y₀)
    (hbal₀ : ∑ i, p₀ i * x₀ i = y₀)
    (hbal₁ : ∑ i, (t * p₀ i) * x₁ i = t * y₀)
    -- WARP: if x₁ affordable at (p₀, y₀) and x₀ ≠ x₁, then x₀ not affordable at (t·p₀, t·y₀)
    (warp : ∑ i, p₀ i * x₁ i ≤ y₀ → x₀ ≠ x₁ →
            ∑ i, (t * p₀ i) * x₀ i > t * y₀) :
    x₀ = x₁ := by
  by_contra hne
  have factor : ∀ z : Fin n → ℝ,
      ∑ i, (t * p₀ i) * z i = t * ∑ i, p₀ i * z i := fun z => by
    rw [Finset.mul_sum]; apply Finset.sum_congr rfl; intros; ring
  have key : ∑ i, p₀ i * x₁ i = y₀ :=
    mul_left_cancel₀ ht.ne' ((factor x₁).symm.trans hbal₁)
  have heq : ∑ i, (t * p₀ i) * x₀ i = t * y₀ := by rw [factor x₀, hbal₀]
  linarith [warp key.le hne]