import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Claim_2_1_1_a {n : ℕ} (p : Fin n → ℝ) (c : ℝ) :
    IsClosed {x : Fin n → ℝ | (∀ i, 0 ≤ x i) ∧ c ≤ ∑ i : Fin n, p i * x i} ∧
    Convex ℝ {x : Fin n → ℝ | (∀ i, 0 ≤ x i) ∧ c ≤ ∑ i : Fin n, p i * x i} := by
  refine ⟨?_, ?_⟩
  · -- Closedness: intersection of closed nonneg orthant and closed half-space
    have h1 : IsClosed {x : Fin n → ℝ | ∀ i, 0 ≤ x i} := by
      have : {x : Fin n → ℝ | ∀ i, 0 ≤ x i} = ⋂ (i : Fin n), {x : Fin n → ℝ | 0 ≤ x i} := by
        ext x; simp [Set.mem_inter_iff]
      rw [this]
      exact isClosed_iInter fun i => isClosed_le continuous_const (continuous_apply i)
    have h2 : IsClosed {x : Fin n → ℝ | c ≤ ∑ i : Fin n, p i * x i} :=
      isClosed_le continuous_const
        (continuous_finset_sum _ fun i _ => continuous_const.mul (continuous_apply i))
    exact h1.inter h2
  · -- Convexity
    intro x hx y hy a b ha hb hab
    refine ⟨fun i => ?_, ?_⟩
    · simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
      exact add_nonneg (mul_nonneg ha (hx.1 i)) (mul_nonneg hb (hy.1 i))
    · simp_rw [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
      have key : ∑ i : Fin n, p i * (a * x i + b * y i) =
          a * (∑ i : Fin n, p i * x i) + b * (∑ i : Fin n, p i * y i) := by
        trans ∑ i : Fin n, (a * (p i * x i) + b * (p i * y i))
        · exact Finset.sum_congr rfl fun i _ => by ring
        · rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum]
      linarith [mul_le_mul_of_nonneg_left hx.2 ha, mul_le_mul_of_nonneg_left hy.2 hb,
                show a * c + b * c = c from by rw [← add_mul, hab, one_mul]]