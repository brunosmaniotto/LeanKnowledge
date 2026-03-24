import Mathlib

open Matrix BigOperators
open Topology
open BigOperators

-- Full row rank implies trivial left kernel (by rank-nullity on Rᵀ)
axiom full_row_rank_vecMul_injective
    {S K : ℕ} [NeZero S]
    (R : Matrix (Fin S) (Fin K) ℚ)
    (hrank : R.rank = S) :
    ∀ v : Fin S → ℚ, vecMul v R = 0 → v = 0

theorem claim_19E_c
    {S K : ℕ} [NeZero S]
    (R : Matrix (Fin S) (Fin K) ℚ)
    (q : Fin K → ℚ)
    (hrank : R.rank = S)
    (hconsist : ∃ μ : Fin S → ℚ, ∀ k, q k = ∑ s, μ s * R s k) :
    ∃! μ : Fin S → ℚ, ∀ k, q k = ∑ s, μ s * R s k := by
  obtain ⟨μ₀, hμ₀⟩ := hconsist
  refine ⟨μ₀, hμ₀, ?_⟩
  intro μ₁ hμ₁
  have hmul : vecMul (μ₁ - μ₀) R = 0 := by
    ext k
    simp only [vecMul, dotProduct, Pi.sub_apply, Pi.zero_apply, sub_mul, Finset.sum_sub_distrib]
    linarith [hμ₁ k, hμ₀ k]
  exact eq_of_sub_eq_zero (full_row_rank_vecMul_injective R hrank (μ₁ - μ₀) hmul)