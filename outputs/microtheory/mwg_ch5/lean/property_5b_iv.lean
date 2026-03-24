import Mathlib
open Topology

/-- Property (iv): Possibility of inaction. The zero vector belongs to the production set,
    meaning complete shutdown is always feasible. -/
class PossibilityOfInaction {n : ℕ} (Y : Set (Fin n → ℝ)) : Prop where
  zero_mem : (0 : Fin n → ℝ) ∈ Y