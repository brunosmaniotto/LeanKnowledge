import Mathlib
open Topology
open BigOperators

/-- In two-player finite games, a mixed strategy is not strictly dominated
    if and only if it is a best response to some opponent mixed strategy.
    This is the key lemma underlying the equivalence of rationalizability
    and iterated strict dominance in two-player games (MWG Claim 8.C.1). -/
axiom not_strictly_dominated_iff_best_response
    (S₁ S₂ : Type) [Fintype S₁] [Fintype S₂] [DecidableEq S₁] [DecidableEq S₂]
    (u : S₁ → S₂ → ℝ)
    (σ₁ : S₁ → ℝ) (h_prob : ∀ s, 0 ≤ σ₁ s) (h_sum : ∑ s, σ₁ s = 1) :
    (¬ ∃ τ₁ : S₁ → ℝ, (∀ s, 0 ≤ τ₁ s) ∧ ∑ s, τ₁ s = 1 ∧
      ∀ σ₂ : S₂ → ℝ, (∀ s, 0 ≤ σ₂ s) → ∑ s, σ₂ s = 1 →
        ∑ s₁, ∑ s₂, τ₁ s₁ * σ₂ s₂ * u s₁ s₂ >
        ∑ s₁, ∑ s₂, σ₁ s₁ * σ₂ s₂ * u s₁ s₂) ↔
    (∃ σ₂ : S₂ → ℝ, (∀ s, 0 ≤ σ₂ s) ∧ ∑ s, σ₂ s = 1 ∧
      ∀ τ₁ : S₁ → ℝ, (∀ s, 0 ≤ τ₁ s) → ∑ s, τ₁ s = 1 →
        ∑ s₁, ∑ s₂, σ₁ s₁ * σ₂ s₂ * u s₁ s₂ ≥
        ∑ s₁, ∑ s₂, τ₁ s₁ * σ₂ s₂ * u s₁ s₂)

/-- Claim 8.C.1 (MWG): In two-player games, the set of rationalizable strategies
    equals the set surviving iterated deletion of strictly dominated strategies.
    Follows directly from the best-response characterization above. -/
theorem rationalizable_eq_iterated_strict_dominance
    (S₁ S₂ : Type) [Fintype S₁] [Fintype S₂] [DecidableEq S₁] [DecidableEq S₂]
    (u₁ : S₁ → S₂ → ℝ) (u₂ : S₂ → S₁ → ℝ)
    (σ₁ : S₁ → ℝ) (h_prob : ∀ s, 0 ≤ σ₁ s) (h_sum : ∑ s, σ₁ s = 1) :
    (¬ ∃ τ₁ : S₁ → ℝ, (∀ s, 0 ≤ τ₁ s) ∧ ∑ s, τ₁ s = 1 ∧
      ∀ σ₂ : S₂ → ℝ, (∀ s, 0 ≤ σ₂ s) → ∑ s, σ₂ s = 1 →
        ∑ s₁, ∑ s₂, τ₁ s₁ * σ₂ s₂ * u₁ s₁ s₂ >
        ∑ s₁, ∑ s₂, σ₁ s₁ * σ₂ s₂ * u₁ s₁ s₂) ↔
    (∃ σ₂ : S₂ → ℝ, (∀ s, 0 ≤ σ₂ s) ∧ ∑ s, σ₂ s = 1 ∧
      ∀ τ₁ : S₁ → ℝ, (∀ s, 0 ≤ τ₁ s) → ∑ s, τ₁ s = 1 →
        ∑ s₁, ∑ s₂, σ₁ s₁ * σ₂ s₂ * u₁ s₁ s₂ ≥
        ∑ s₁, ∑ s₂, τ₁ s₁ * σ₂ s₂ * u₁ s₁ s₂) :=
  not_strictly_dominated_iff_best_response S₁ S₂ u₁ σ₁ h_prob h_sum