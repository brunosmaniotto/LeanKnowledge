import Mathlib

open Set Metric

def MWG.IsOpenRelative {N : ℕ} (X A : Set (EuclideanSpace ℝ (Fin N))) : Prop :=
  A ⊆ X ∧ ∀ x ∈ A, ∃ ε > 0, ∀ x' ∈ X, dist x' x < ε → x' ∈ A