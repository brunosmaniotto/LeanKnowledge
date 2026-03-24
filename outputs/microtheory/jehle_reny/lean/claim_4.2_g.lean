import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- At the joint profit-maximizing output vector q̄, each firm's marginal profit
    with respect to its own output is strictly positive: ∂π_k(q̄)/∂q_k > 0.
    This follows from the joint FOC (∑_j ∂π_j/∂q_k = 0) and negative cross-partials
    (∂π_j/∂q_k < 0 for j ≠ k). The collusive solution is not self-enforcing. -/
theorem Claim_4_2_g {J : ℕ} (hJ : 2 ≤ J) (k : Fin J)
    (dπ : Fin J → Fin J → ℝ)
    -- dπ j k represents ∂π_j/∂q_k evaluated at the joint-profit-maximizing vector q̄
    (hFOC : ∑ j : Fin J, dπ j k = 0)
    (hcross : ∀ j : Fin J, j ≠ k → dπ j k < 0) :
    dπ k k > 0 := by
  -- univ \ {k} is nonempty since J ≥ 2
  have hne : (univ.erase k : Finset (Fin J)).Nonempty := by
    apply card_pos.mp
    rw [card_erase_of_mem (mem_univ k), card_univ, Fintype.card_fin]
    omega
  -- Split: dπ k k + ∑_{j≠k} dπ j k = 0
  have hkey : dπ k k + ∑ j ∈ univ.erase k, dπ j k = 0 := by
    have := add_sum_erase univ (fun j => dπ j k) (mem_univ k)
    linarith
  -- ∑_{j≠k} dπ j k < 0 since each term is negative
  obtain ⟨i₀, hi₀⟩ := hne
  have hsum_neg : ∑ j ∈ univ.erase k, dπ j k < 0 := by
    have h := sum_lt_sum
      (fun i (hi : i ∈ univ.erase k) => le_of_lt (hcross i (mem_erase.mp hi).1))
      ⟨i₀, hi₀, hcross i₀ (mem_erase.mp hi₀).1⟩
    simp only [sum_const_zero] at h
    exact h
  -- Therefore dπ k k > 0
  linarith