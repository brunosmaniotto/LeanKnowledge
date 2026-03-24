import Mathlib

/-- A ring is nonempty because it contains the additive identity (zero). -/
theorem Ring.nonempty (R : Type _) [Ring R] : Nonempty R :=
  ⟨0⟩