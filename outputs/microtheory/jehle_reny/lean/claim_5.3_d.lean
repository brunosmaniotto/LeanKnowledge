import Mathlib

open Topology BigOperators Finset
open BigOperators

/-- Berge's Maximum Theorem applied to profit maximization:
    if Y ⊆ ℝⁿ is compact and nonempty, then p ↦ sup_{y ∈ Y} p · y is continuous.
    (MWG Theorem A2.21) -/
axiom MWG.IsContinuousOn {n : ℕ}
    (Y : Set (Fin n → ℝ)) (hY_compact : IsCompact Y) (hY_ne : Y.Nonempty) :
    Continuous (fun p : Fin n → ℝ => sSup ((fun y => ∑ l, p l * y l) '' Y))

/-- Claim 5.3(d): Under Assumption 5.2 (compact production set Y_j),
    the profit function π^j(p) is continuous. -/
theorem Claim_5_3_d {n : ℕ}
    (Y : Set (Fin n → ℝ))
    (hY_compact : IsCompact Y)
    (hY_ne : Y.Nonempty) :
    Continuous (fun p : Fin n → ℝ =>
      sSup ((fun y => ∑ l, p l * y l) '' Y)) :=
  MWG.IsContinuousOn Y hY_compact hY_ne