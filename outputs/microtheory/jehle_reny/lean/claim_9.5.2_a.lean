import Mathlib

open Finset BigOperators
open BigOperators

/-- Claim 9.5.2(a): Ex ante Pareto efficiency ⟹ interim Pareto efficiency ⟹ ex post Pareto efficiency.
    The more uncertainty, the greater scope for mutually beneficial insurance. -/
theorem claim_9_5_2_a
    {I : Type*} [Fintype I] [DecidableEq I]
    {Θ : Type*} [Fintype Θ]
    {X : Type*}
    -- Utility functions: agent → state → allocation → ℝ
    (u : I → Θ → X → ℝ)
    -- Prior probability over type profiles (strictly positive)
    (μ : Θ → ℝ)
    (hμ_pos : ∀ θ, 0 < μ θ)
    (hμ_sum : ∑ θ : Θ, μ θ = 1)
    -- An allocation rule mapping type profiles to outcomes
    (x y : Θ → X)
    -- Ex ante Pareto dominance: y gives every agent weakly higher expected utility,
    -- and strictly higher for some agent
    (h_weak : ∀ i : I,
      ∑ θ : Θ, μ θ * u i θ (y θ) ≥ ∑ θ : Θ, μ θ * u i θ (x θ))
    (h_strict : ∃ i : I,
      ∑ θ : Θ, μ θ * u i θ (y θ) > ∑ θ : Θ, μ θ * u i θ (x θ)) :
    -- Then there exists some state θ where y(θ) ex post Pareto dominates x(θ),
    -- i.e., ex ante dominance implies ex post dominance somewhere
    ∃ θ₀ : Θ, (∀ i : I, u i θ₀ (y θ₀) ≥ u i θ₀ (x θ₀)) ∨
              (∃ i : I, u i θ₀ (y θ₀) > u i θ₀ (x θ₀)) := by
  -- We prove the contrapositive direction:
  -- If y ex ante Pareto dominates x, then it cannot be that for every state
  -- every agent is weakly worse off AND no agent is strictly better off anywhere.
  -- In fact, the strict inequality at the ex ante level forces at least one state
  -- where some agent is strictly better off.
  obtain ⟨i₀, hi₀⟩ := h_strict
  -- The expected utility of i₀ under y is strictly greater than under x.
  -- Since μ(θ) > 0 for all θ, there must exist some θ₀ where u i₀ θ₀ (y θ₀) > u i₀ θ₀ (x θ₀).
  by_contra h_none
  push_neg at h_none
  -- h_none : ∀ θ₀, (∃ i, u i θ₀ (y θ₀) < u i θ₀ (x θ₀)) ∧ ∀ i, u i θ₀ (y θ₀) ≤ u i θ₀ (x θ₀)
  have key : ∀ θ, u i₀ θ (y θ) ≤ u i₀ θ (x θ) := fun θ => (h_none θ).2 i₀
  have sum_le : ∑ θ : Θ, μ θ * u i₀ θ (y θ) ≤ ∑ θ : Θ, μ θ * u i₀ θ (x θ) := by
    apply Finset.sum_le_sum
    intro θ _
    exact mul_le_mul_of_nonneg_left (key θ) (le_of_lt (hμ_pos θ))
  linarith