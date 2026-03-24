import Mathlib
open Finset

/-- Project alternatives: swimming pool (S) or bridge (B). -/
inductive Project93
  | S
  | B

/-- Valuation: v(S, t) = t + 5, v(B, t) = 2t. -/
noncomputable def valuation93 (x : Project93) (t : ℝ) : ℝ :=
  match x with
  | .S => t + 5
  | .B => 2 * t

/-- Type space: {1, 2, ..., 9}. -/
def typeSpace93 : Finset ℕ := Finset.Icc 1 9

/-- Example 9.3 setting: N individuals, quasi-linear preferences over {S, B},
    types drawn uniformly and independently from {1,...,9}. -/
structure SmallTownSetting where
  N : ℕ
  hN : 0 < N
  types : Fin N → ℕ
  types_valid : ∀ i, types i ∈ typeSpace93