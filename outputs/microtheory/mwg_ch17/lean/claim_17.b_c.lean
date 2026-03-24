import Mathlib
open Topology

/-- A Walrasian equilibrium price vector is one where production-inclusive
    excess demand equals zero. This is definitionally equivalent. -/
theorem claim_17B_c (L : ℕ) (excessDemand : (Fin L → ℝ) → (Fin L → ℝ))
    (p : Fin L → ℝ) :
    (∀ l, excessDemand p l = 0) ↔ excessDemand p = 0 := by
  constructor
  · intro h
    ext l
    simp [h l]
  · intro h l
    simp [h]