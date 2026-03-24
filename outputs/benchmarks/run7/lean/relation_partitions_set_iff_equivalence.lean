import Mathlib.Data.Setoid.Partition

open Set Setoid

variable {S : Type*}

/-- The equivalence classes of a relation `r` as a set of subsets of `S`. -/
def classes (r : S → S → Prop) : Set (Set S) :=
  Set.range (fun x : S => {y | r x y})