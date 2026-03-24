import Mathlib

/-- A sequence `sub` is a subsequence of `seq` if there exists a strictly increasing
    function `m : ℕ → ℕ` such that `sub = seq ∘ m`. -/
def MWG.IsSubsequence (seq sub : ℕ → α) : Prop :=
  ∃ m : ℕ → ℕ, StrictMono m ∧ sub = seq ∘ m