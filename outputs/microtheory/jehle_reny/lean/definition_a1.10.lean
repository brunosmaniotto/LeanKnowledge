import Mathlib

open Metric Set

/-- Definition A1.10 (MWG). A subset `S` of `D ⊆ ℝᵐ` is **open in D** if for every
    `x ∈ S` there exists `ε > 0` such that `B_ε(x) ∩ D ⊆ S`. -/
def MWG.IsOpenRelative {m : ℕ} (D S : Set (EuclideanSpace ℝ (Fin m))) : Prop :=
  S ⊆ D ∧ ∀ x ∈ S, ∃ ε > 0, ball x ε ∩ D ⊆ S