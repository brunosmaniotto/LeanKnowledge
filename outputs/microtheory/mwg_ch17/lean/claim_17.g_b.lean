import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem claim_17G_b {n : ℕ} (hn : 0 < n) (δ : ℝ) (hδ : 0 < δ)
    (w : Fin n → ℝ)
    (v : Fin n → ℝ)
    (hv0 : v ⟨0, hn⟩ = -δ)
    (hvk : ∀ k : Fin n, k ≠ ⟨0, hn⟩ → v k = 0)
    (hdot : ∑ i : Fin n, v i * w i ≥ 0) :
    w ⟨0, hn⟩ ≤ 0 := by
  have hsum : ∑ i : Fin n, v i * w i = v ⟨0, hn⟩ * w ⟨0, hn⟩ := by
    apply Finset.sum_eq_single_of_mem (⟨0, hn⟩ : Fin n) (Finset.mem_univ _)
    intro b _ hb
    rw [hvk b hb, zero_mul]
  rw [hsum, hv0] at hdot
  nlinarith