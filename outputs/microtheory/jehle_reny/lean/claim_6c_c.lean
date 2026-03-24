import Mathlib
open Topology

/-- Different strictly increasing transformations can reverse cross-individual utility comparisons,
    but identical ones preserve them. -/
theorem cross_individual_utility_comparison :
    -- Part 1: There exist strictly increasing ψ₁, ψ₂ and values where u_i(x) ≥ u_j(y)
    -- but ψ₁(u_i(x)) < ψ₂(u_j(y))
    (∃ (ψ₁ ψ₂ : ℝ → ℝ), StrictMono ψ₁ ∧ StrictMono ψ₂ ∧
      ∃ (a b : ℝ), a ≥ b ∧ ψ₁ a < ψ₂ b) ∧
    -- Part 2: If ψ is strictly increasing, then a ≥ b → ψ(a) ≥ ψ(b)
    (∀ (ψ : ℝ → ℝ), StrictMono ψ →
      ∀ (a b : ℝ), a ≥ b → ψ a ≥ ψ b) := by
  constructor
  · -- Counterexample: ψ₁ = id, ψ₂ = (· + 10), a = 1, b = 1
    refine ⟨id, (· + 10), strictMono_id, fun a b hab => by linarith, 1, 1, le_refl 1, ?_⟩
    norm_num
  · intro ψ hψ a b hab
    rcases eq_or_lt_of_le hab with h | h
    · exact le_of_eq (congrArg ψ h)
    · exact le_of_lt (hψ h)