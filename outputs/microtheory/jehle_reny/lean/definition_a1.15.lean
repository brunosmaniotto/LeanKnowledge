import Mathlib

open Set

/-- Definition A1.15: `{xᵏ}_{k∈J}` is a subsequence of `{xᵏ}_{k∈I}` in ℝⁿ
    if `J` is an infinite subset of `I`. -/
def MWG.IsSubsequence (I J : Set ℕ) : Prop :=
  J ⊆ I ∧ J.Infinite