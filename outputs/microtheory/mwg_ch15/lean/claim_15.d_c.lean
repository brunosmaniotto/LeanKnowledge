import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/--
The equilibrium factor allocation is exactly the factor allocation chosen by a
revenue-maximizing planner. Since each firm maximizes pⱼfⱼ(zⱼ) − w·zⱼ and
market clearing gives Σⱼ zⱼ = z̄, the total cost w·z̄ is constant across
feasible allocations, so joint profit maximization reduces to revenue maximization.
-/
theorem equilibrium_is_revenue_maximizing_allocation
    {J : ℕ} (p : Fin J → ℝ) (f : Fin J → ℝ → ℝ) (w : ℝ) (z_bar : ℝ)
    (z_star : Fin J → ℝ)
    -- Market clearing: total factor demand equals endowment
    (h_clearing : ∑ j : Fin J, z_star j = z_bar)
    -- Each firm's allocation is non-negative
    (h_nonneg : ∀ j, 0 ≤ z_star j)
    -- z_star maximizes joint profit: for any feasible allocation z,
    -- total profit at z_star is at least total profit at z
    (h_profit_max : ∀ z : Fin J → ℝ,
      (∀ j, 0 ≤ z j) →
      ∑ j : Fin J, z j = z_bar →
      ∑ j : Fin J, (p j * f j (z_star j) - w * z_star j) ≥
      ∑ j : Fin J, (p j * f j (z j) - w * z j)) :
    -- Then z_star also maximizes total revenue among feasible allocations
    ∀ z : Fin J → ℝ,
      (∀ j, 0 ≤ z j) →
      ∑ j : Fin J, z j = z_bar →
      ∑ j : Fin J, p j * f j (z_star j) ≥ ∑ j : Fin J, p j * f j (z j) := by
  intro z hz_nonneg hz_sum
  have h := h_profit_max z hz_nonneg hz_sum
  -- Rewrite sums: Σ(pf - wz) = Σpf - w·Σz
  have cost_star : ∑ j : Fin J, (p j * f j (z_star j) - w * z_star j) =
      ∑ j : Fin J, p j * f j (z_star j) - w * ∑ j : Fin J, z_star j := by
    rw [Finset.sum_sub_distrib, ← Finset.mul_sum]
  have cost_z : ∑ j : Fin J, (p j * f j (z j) - w * z j) =
      ∑ j : Fin J, p j * f j (z j) - w * ∑ j : Fin J, z j := by
    rw [Finset.sum_sub_distrib, ← Finset.mul_sum]
  rw [cost_star, cost_z, h_clearing, hz_sum] at h
  linarith