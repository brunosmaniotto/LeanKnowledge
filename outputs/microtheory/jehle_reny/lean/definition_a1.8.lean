import Mathlib
open Topology

namespace MWG

/-- A set S ⊂ ℝⁿ is compact if it is closed and bounded (Definition A1.8, Heine-Borel). -/
def IsCompactHB {n : ℕ} (S : Set (EuclideanSpace ℝ (Fin n))) : Prop :=
  IsClosed S ∧ Bornology.IsBounded S

end MWG