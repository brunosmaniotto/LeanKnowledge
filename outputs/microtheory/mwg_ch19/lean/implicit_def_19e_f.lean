import Mathlib

/-- An asset is redundant if its return vector lies in the span of the return vectors
    of the remaining assets, i.e., deleting it does not change Range R. -/
def Asset.isRedundant {S K : ℕ} (R : Matrix (Fin S) (Fin K) ℝ) (k : Fin K) : Prop :=
  (fun i => R i k) ∈ Submodule.span ℝ (Set.range (fun j : { j : Fin K // j ≠ k } => fun i => R i j.val))