import Mathlib

open Set

/--
A structure to encapsulate the context of the variable bidder, including their random variable `X`.
`Ω` is the underlying sample space for the random variable.
-/
structure VariableBidderContext (Ω : Type) where
  X : Ω → ℝ

/--
**Theorem** (Claim_II.BB): The difference between the mean results for the Dutch auction
and the common progressive auction procedure, in asymmetrical situations where one bidder
has a fixed value `a` and the other a variable value, varies according to where `a` lies
relative to the range of values for the randomly assigned value of the first bidder.
-/
def Claim_II.BB :=
  -- Quantify over the types and functions involved in the claim
  ∀ (Ω : Type)
    (mean_dutch_val : ℝ → VariableBidderContext Ω → ℝ)
    (mean_progressive_val : ℝ → VariableBidderContext Ω → ℝ),
    ∀ (vbc : VariableBidderContext Ω),
      (Set.range vbc.X).Nonempty →
      (∃ a₁ a₂ : ℝ, a₁ ≠ a₂ ∧
        (mean_dutch_val a₁ vbc - mean_progressive_val a₁ vbc) ≠
        (mean_dutch_val a₂ vbc - mean_progressive_val a₂ vbc))