import Mathlib

open Set Topology

/-- A subset S of D is closed in D if its complement in D is open
    in the subspace topology on D (Definition A1.11). -/
def MWG.HasClosedGraph {m : ℕ} (D S : Set (EuclideanSpace ℝ (Fin m))) : Prop :=
  IsOpen (Subtype.val ⁻¹' (D \ S) : Set ↥D)