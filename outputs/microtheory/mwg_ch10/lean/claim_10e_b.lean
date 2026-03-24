import Mathlib

open BigOperators
open Finset

variable {I J : Type*} [Fintype I] [Fintype J]
variable (φ_i_prime : I → ℝ → ℝ) (c_j_prime : J → ℝ → ℝ)
variable (P : ℝ → ℝ) (C_prime : ℝ → ℝ)
variable (x : ℝ) (x_i : I → ℝ) (q_j : J → ℝ)
variable (dx : ℝ) (dx_i : I → ℝ) (dq_j : J → ℝ)

theorem Claim_10E_b :
  (∀ i : I, φ_i_prime i (x_i i) = P x) →
  (∀ j : J, c_j_prime j (q_j j) = C_prime x) →
  (∑ i : I, dx_i i = dx) →
  (∑ j : J, dq_j j = dx) →
  (∑ i : I, φ_i_prime i (x_i i) * dx_i i - ∑ j : J, c_j_prime j (q_j j) * dq_j j) =
  (P x - C_prime x) * dx :=
by
  intros h_phi h_c h_sum_dx_i h_sum_dq_j
  simp_rw [h_phi, h_c]
  rw [←mul_sum, ←mul_sum]
  rw [h_sum_dx_i, h_sum_dq_j]
  ring