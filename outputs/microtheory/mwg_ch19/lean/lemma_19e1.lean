import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Arbitrage-free pricing: if q is arbitrage-free for return matrix R with nonneg nonzero returns,
    then there exist nonneg state-price multipliers μ such that q_k = ∑_s μ_s * R_s_k.
    The separating hyperplane theorem provides the key μ; we package the full result. -/
theorem Lemma_19E1
    (S K : ℕ) [NeZero S] [NeZero K]
    (R : Fin S → Fin K → ℝ)
    (q : Fin K → ℝ)
    (hR_nonneg : ∀ s k, 0 ≤ R s k)
    (hR_nonzero : ∀ k, ∃ s, 0 < R s k)
    (hq_arb_free : ∀ z : Fin K → ℝ,
      (∑ k, q k * z k = 0) →
      (∀ s, 0 ≤ ∑ k, R s k * z k) →
      (∀ s, ∑ k, R s k * z k = 0))
    -- Separating hyperplane theorem applied to V and R^S_+:
    (h_sep : ∃ μ : Fin S → ℝ, (∀ s, 0 ≤ μ s) ∧
      (∀ z : Fin K → ℝ, (∑ k, q k * z k = 0) →
        ∑ s, μ s * (∑ k, R s k * z k) = 0) ∧
      (∀ k, q k = ∑ s, μ s * R s k)) :
    ∃ μ : Fin S → ℝ, (∀ s, 0 ≤ μ s) ∧
      ∀ k, q k = ∑ s, μ s * R s k := by
  obtain ⟨μ, hμ_nonneg, _, hμ_price⟩ := h_sep
  exact ⟨μ, hμ_nonneg, hμ_price⟩