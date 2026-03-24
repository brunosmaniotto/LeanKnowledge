import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem gross_substitution_diagonal_negative
    {n : ℕ} (hn : 1 < n)
    (Dz : Fin n → Fin n → ℝ)
    (p : Fin n → ℝ)
    (hp_pos : ∀ i, 0 < p i)
    (h_offdiag_pos : ∀ k ℓ : Fin n, k ≠ ℓ → 0 < Dz ℓ k)
    (h_homog : ∀ ℓ : Fin n, ∑ k, Dz ℓ k * p k = 0) :
    ∀ ℓ : Fin n, Dz ℓ ℓ < 0 := by
  intro ℓ
  have h_eq := h_homog ℓ
  have h_split : Dz ℓ ℓ * p ℓ + ∑ k ∈ Finset.univ.erase ℓ, Dz ℓ k * p k = ∑ k, Dz ℓ k * p k :=
    Finset.add_sum_erase Finset.univ (fun k => Dz ℓ k * p k) (Finset.mem_univ ℓ)
  have h_sum_pos : 0 < ∑ k ∈ Finset.univ.erase ℓ, Dz ℓ k * p k := by
    apply Finset.sum_pos
    · intro k hk
      exact mul_pos (h_offdiag_pos k ℓ (Finset.ne_of_mem_erase hk)) (hp_pos k)
    · have : 0 < Finset.card (Finset.univ.erase ℓ) := by
        simp [Finset.card_erase_of_mem (Finset.mem_univ ℓ), Finset.card_fin]
        omega
      exact Finset.card_pos.mp this
  nlinarith [hp_pos ℓ]