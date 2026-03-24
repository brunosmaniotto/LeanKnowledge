import Mathlib
open Topology

noncomputable section

/-- Robinson Crusoe production set: Y = {(-h, y) | 0 ≤ h ≤ b, 0 ≤ y ≤ h^α} -/
def RC_ProductionSet (b α : ℝ) : Set (Fin 2 → ℝ) :=
  { v | 0 ≤ -v 0 ∧ -v 0 ≤ b ∧ 0 ≤ v 1 ∧ v 1 ≤ (-v 0) ^ α }

/-- Walrasian equilibrium existence for the Robinson Crusoe economy. -/
axiom rc_equilibrium_exists (b α β T : ℝ)
    (hb : 0 < b) (hα0 : 0 < α) (hα1 : α < 1)
    (hβ0 : 0 < β) (hβ1 : β < 1) (hT : 0 < T) (hbT : T < b) :
    ∃ p : Fin 2 → ℝ, (∀ i, 0 < p i)