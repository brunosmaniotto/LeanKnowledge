import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem walrasian_equilibrium_positive_prices_and_market_clearing
    {L : ℕ} (hL : 0 < L)
    (p : Fin L → ℝ)
    (z : (Fin L → ℝ) → Fin L → ℝ)
    (strongly_monotone : Prop)
    (h_free_good : strongly_monotone → ∀ ℓ : Fin L, p ℓ ≤ 0 → z p ℓ > 0)
    (h_walras_law : ∑ ℓ : Fin L, p ℓ * z p ℓ = 0)
    (h_eq : ∀ ℓ : Fin L, z p ℓ ≤ 0)
    (h_sm : strongly_monotone) :
    (∀ ℓ : Fin L, p ℓ > 0) ∧
    (∀ ℓ : Fin L, z p ℓ = 0) := by
  have hp : ∀ ℓ : Fin L, p ℓ > 0 := by
    intro ℓ
    by_contra h
    push_neg at h
    have := h_free_good h_sm ℓ h
    linarith [h_eq ℓ]
  constructor
  · exact hp
  · have h_nonpos : ∀ ℓ ∈ Finset.univ, p ℓ * z p ℓ ≤ 0 := by
      intro ℓ _
      exact mul_nonpos_of_nonneg_of_nonpos (le_of_lt (hp ℓ)) (h_eq ℓ)
    have h_zero : ∀ ℓ ∈ Finset.univ, p ℓ * z p ℓ = 0 := by
      by_contra h_not
      push_neg at h_not
      obtain ⟨ℓ₀, hℓ₀_mem, hℓ₀⟩ := h_not
      have hℓ₀_neg : p ℓ₀ * z p ℓ₀ < 0 :=
        lt_of_le_of_ne (h_nonpos ℓ₀ hℓ₀_mem) hℓ₀
      have hslt : ∑ ℓ : Fin L, p ℓ * z p ℓ < ∑ ℓ : Fin L, (0 : ℝ) :=
        Finset.sum_lt_sum h_nonpos ⟨ℓ₀, Finset.mem_univ ℓ₀, hℓ₀_neg⟩
      simp at hslt
      linarith
    intro ℓ
    have := h_zero ℓ (Finset.mem_univ ℓ)
    exact (mul_eq_zero.mp this).resolve_left (ne_of_gt (hp ℓ))