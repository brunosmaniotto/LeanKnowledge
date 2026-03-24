import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The FOC (8.8) w.r.t. premium p is redundant: it equals the sum of the FOCs (8.9)
    w.r.t. each B_l, given that probabilities sum to 1. Hence the system has at most
    L+2 independent equations in L+3 unknowns (p, B₀,…,B_L, λ). -/
theorem Claim_8_FOC_redundancy
    {n : ℕ}
    (π : Fin n → ℝ)
    (u' : Fin n → ℝ)
    (lam : ℝ)
    (hπ_sum : ∑ l : Fin n, π l = 1)
    (h_foc89 : ∀ l : Fin n, lam * (π l * u' l) = π l)
    : 1 - lam * ∑ l : Fin n, π l * u' l = 0 := by
  suffices lam * ∑ l : Fin n, π l * u' l = 1 by linarith
  rw [Finset.mul_sum]; simp_rw [h_foc89]; exact hπ_sum