import Mathlib

open BigOperators Finset
open Topology

theorem Claim_6B_h (n : ℕ) (u : Fin n → ℝ)
    (p q r : Fin n → ℝ) (α : ℝ) (hα : 0 < α) :
    let EU := fun v : Fin n → ℝ => ∑ i, v i * u i
    EU p ≥ EU q ↔
    EU (fun i => α * p i + (1 - α) * r i) ≥ EU (fun i => α * q i + (1 - α) * r i) := by
  simp only
  have hp : ∑ i : Fin n, (α * p i + (1 - α) * r i) * u i =
            α * ∑ i, p i * u i + (1 - α) * ∑ i, r i * u i := by
    conv_lhs => arg 2; ext i; rw [show (α * p i + (1 - α) * r i) * u i = α * (p i * u i) + (1 - α) * (r i * u i) by ring]
    rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum]
  have hq : ∑ i : Fin n, (α * q i + (1 - α) * r i) * u i =
            α * ∑ i, q i * u i + (1 - α) * ∑ i, r i * u i := by
    conv_lhs => arg 2; ext i; rw [show (α * q i + (1 - α) * r i) * u i = α * (q i * u i) + (1 - α) * (r i * u i) by ring]
    rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum]
  rw [hp, hq]
  constructor
  · intro h; nlinarith
  · intro h; nlinarith