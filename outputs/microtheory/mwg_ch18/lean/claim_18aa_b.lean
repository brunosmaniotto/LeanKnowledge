import Mathlib
open Topology
open BigOperators

-- Single-input production game with constant average product (linear f)
-- If f(z)/z = c (constant), then f(z) = c * z, and the proportional allocation
-- x_i = c * ω_i is the unique core allocation.

noncomputable section

variable {n : ℕ} (hn : 0 < n)

-- We model players as Fin n, each with endowment ω_i > 0
-- Production function f(z) = c * z (constant average product c > 0)
-- An allocation x is in the core if:
--   (1) Efficiency: ∑ x_i = f(∑ ω_i) = c * ∑ ω_i
--   (2) No coalition S can block: for all S ≠ ∅, ∑_{i∈S} x_i ≥ f(∑_{i∈S} ω_i) = c * ∑_{i∈S} ω_i
-- The proportional allocation is x_i = c * ω_i.
-- Uniqueness: (2) with S = {i} gives x_i ≥ c * ω_i for all i.
--   Summing over all i: ∑ x_i ≥ c * ∑ ω_i = ∑ x_i by (1). So equality holds everywhere.

theorem proportional_allocation_unique_core
    (N : Finset ι) (hN : N.Nonempty)
    (ω : ι → ℝ) (hω : ∀ i ∈ N, 0 < ω i)
    (c : ℝ) (hc : 0 < c)
    (x : ι → ℝ)
    -- Efficiency: total output equals c * total endowment
    (h_eff : ∑ i ∈ N, x i = c * ∑ i ∈ N, ω i)
    -- Core condition: no coalition can improve (each singleton gets at least c * ω_i)
    (h_core : ∀ i ∈ N, x i ≥ c * ω i) :
    ∀ i ∈ N, x i = c * ω i := by
  -- From h_core: x_i ≥ c * ω_i for all i
  -- Summing: ∑ x_i ≥ c * ∑ ω_i = ∑ x_i (by h_eff)
  -- So ∑ x_i ≥ ∑ x_i, meaning all inequalities are equalities
  have h_sum_ge : ∑ i ∈ N, x i ≥ ∑ i ∈ N, c * ω i := by
    exact Finset.sum_le_sum h_core
  rw [← Finset.mul_sum] at h_sum_ge
  have h_eq : ∑ i ∈ N, x i = ∑ i ∈ N, c * ω i := by
    rw [← Finset.mul_sum]; linarith
  intro i hi
  by_contra h_ne
  have h_strict : x i > c * ω i := by
    cases lt_or_gt_of_ne h_ne with
    | inl hlt => linarith [h_core i hi]
    | inr hgt => exact hgt
  have : ∑ j ∈ N, x j > ∑ j ∈ N, c * ω j := by
    exact Finset.sum_lt_sum h_core ⟨i, hi, h_strict⟩
  linarith

end