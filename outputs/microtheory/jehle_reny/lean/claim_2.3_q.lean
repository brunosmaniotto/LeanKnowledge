import Mathlib
open Topology

/-- With only a finite amount of data, the consumer's preferences are not completely
    pinned down at bundles 'out-of-sample'. There can be many different utility functions
    that rationalise the same finite data set. -/
theorem Claim_2_3_q :
    ∃ (u₁ u₂ : ℝ → ℝ),
      -- Both agree on the observed (finite) data set {0}
      (∀ x ∈ ({0} : Finset ℝ), u₁ x = u₂ x) ∧
      -- Both rationalise the data (preserve the ordering on observed points)
      (u₁ 0 = 0 ∧ u₂ 0 = 0) ∧
      -- But they disagree out-of-sample
      (∃ y : ℝ, u₁ y ≠ u₂ y) := by
  refine ⟨fun x => x, fun x => 2 * x, ?_, ?_, ?_⟩
  · intro x hx
    simp at hx
    subst hx
    ring
  · constructor <;> ring
  · exact ⟨1, by norm_num⟩