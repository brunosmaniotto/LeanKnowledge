import Mathlib

open Finset BigOperators Real
open Topology
open BigOperators

noncomputable def genCES {n : ℕ} (A : ℝ) (α : Fin n → ℝ) (ρ β : ℝ)
    (x : Fin n → ℝ) : ℝ :=
  A * (∑ i : Fin n, α i * (x i) ^ ρ) ^ (β / ρ)

theorem Exercise_3_13 {n : ℕ} (A : ℝ) (α : Fin n → ℝ) (ρ β t : ℝ)
    (x : Fin n → ℝ) (hρ : ρ ≠ 0) (ht : 0 < t) (hx : ∀ i, 0 < x i)
    (hS : 0 < ∑ i : Fin n, α i * (x i) ^ ρ) :
    genCES A α ρ β (fun i => t * x i) = t ^ β * genCES A α ρ β x := by
  simp only [genCES]
  have ht_nn : (0 : ℝ) ≤ t := le_of_lt ht
  have htρ_nn : (0 : ℝ) ≤ t ^ ρ := le_of_lt (rpow_pos_of_pos ht ρ)
  have hS_nn : (0 : ℝ) ≤ ∑ i, α i * x i ^ ρ := le_of_lt hS
  have hmul : ∀ i : Fin n, (t * x i) ^ ρ = t ^ ρ * (x i) ^ ρ :=
    fun i => mul_rpow ht_nn (le_of_lt (hx i))
  simp_rw [hmul, mul_left_comm (α _) (t ^ ρ), ← Finset.mul_sum]
  rw [mul_rpow htρ_nn hS_nn, ← rpow_mul ht_nn,
      show ρ * (β / ρ) = β from by field_simp]
  ring