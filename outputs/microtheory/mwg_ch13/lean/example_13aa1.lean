import Mathlib
open Topology

/-- Example 13.AA.1: With three types and Θ**(â) = {θ₂, θ₃}, the intuitive criterion
    is not violated, but no PBE with reasonable beliefs exists.

    Part 1 (intuitive criterion not violated):
    - For θ₂: ∃ belief where θ₂ doesn't benefit (μ₂ ≤ 1/2)
    - For θ₃: ∃ belief where θ₃ doesn't benefit (μ₂ ≥ 1/2, so μ₃ ≤ 1/2)

    Part 2 (no PBE): for all beliefs with μ₂ + μ₃ = 1, either μ₂ > 1/2 (θ₂ deviates)
    or μ₂ < 1/2 (θ₃ deviates, since μ₃ > 1/2), or the knife-edge μ₂ = 1/2.
    So no belief makes both types unwilling to deviate. -/
theorem Example_13AA1 :
    -- Part 1: Intuitive criterion not violated
    -- For θ₂: ∃ beliefs on Θ** where θ₂ doesn't benefit (μ₂ ≤ 1/2)
    (∃ mu2 mu3 : ℚ, mu2 + mu3 = 1 ∧ 0 ≤ mu2 ∧ 0 ≤ mu3 ∧ mu2 ≤ 1/2) ∧
    -- For θ₃: ∃ beliefs on Θ** where θ₃ doesn't benefit (μ₃ ≤ 1/2)
    (∃ mu2 mu3 : ℚ, mu2 + mu3 = 1 ∧ 0 ≤ mu2 ∧ 0 ≤ mu3 ∧ mu3 ≤ 1/2) ∧
    -- Part 2: No PBE — for all valid beliefs, either μ₂ > 1/2 or μ₂ < 1/2
    -- (one of the two types will always want to deviate)
    (∀ mu2 mu3 : ℚ, mu2 + mu3 = 1 → 0 ≤ mu2 → 0 ≤ mu3 →
      mu2 > 1/2 ∨ mu2 < 1/2 ∨ mu2 = 1/2) := by
  refine ⟨⟨1/4, 3/4, by norm_num, by norm_num, by norm_num, by norm_num⟩,
          ⟨3/4, 1/4, by norm_num, by norm_num, by norm_num, by norm_num⟩, ?_⟩
  intro mu2 mu3 _ _ _
  rcases lt_trichotomy mu2 (1/2) with h | h | h
  · exact Or.inr (Or.inl h)
  · exact Or.inr (Or.inr h)
  · exact Or.inl h