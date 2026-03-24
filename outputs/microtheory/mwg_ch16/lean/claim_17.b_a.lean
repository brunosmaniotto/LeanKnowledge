import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem walrasian_equilibrium_properties
    {L : Type*} [Fintype L] [DecidableEq L]
    (p z : L → ℝ)
    (hp : ∀ ℓ, 0 ≤ p ℓ)
    (hz : ∀ ℓ, z ℓ ≤ 0)
    (hpz : ∑ ℓ : L, p ℓ * z ℓ = 0) :
    (∀ ℓ, z ℓ ≤ 0) ∧
    (∀ ℓ, p ℓ > 0 → z ℓ = 0) ∧
    (∀ ℓ, z ℓ < 0 → p ℓ = 0) := by
  have hterms : ∀ ℓ, p ℓ * z ℓ ≤ 0 := fun ℓ => mul_nonpos_of_nonneg_of_nonpos (hp ℓ) (hz ℓ)
  have hzero : ∀ ℓ, p ℓ * z ℓ = 0 := by
    by_contra h
    push_neg at h
    obtain ⟨ℓ', hℓ'⟩ := h
    have hlt : p ℓ' * z ℓ' < 0 := lt_of_le_of_ne (hterms ℓ') hℓ'
    have hslt : ∑ ℓ : L, p ℓ * z ℓ < ∑ ℓ : L, (0 : ℝ) := by
      apply Finset.sum_lt_sum
      · intro ℓ _
        linarith [hterms ℓ]
      · exact ⟨ℓ', Finset.mem_univ _, by linarith⟩
    simp at hslt
    linarith
  refine ⟨hz, fun ℓ hpℓ => ?_, fun ℓ hzℓ => ?_⟩
  · exact (mul_eq_zero.mp (hzero ℓ)).resolve_left (ne_of_gt hpℓ)
  · rcases mul_eq_zero.mp (hzero ℓ) with h | h
    · exact h
    · linarith