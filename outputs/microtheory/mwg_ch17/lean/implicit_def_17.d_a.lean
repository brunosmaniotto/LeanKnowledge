import Mathlib
open Topology

/-- An equilibrium price vector is locally unique (locally isolated) if there is no other
    normalized equilibrium price vector arbitrarily close to it. -/
def IsLocallyUniqueEquilibrium
    {n : ℕ} (is_equilibrium : (Fin n → ℝ) → Prop) (is_normalized : (Fin n → ℝ) → Prop)
    (p : Fin n → ℝ) : Prop :=
  is_equilibrium p ∧ is_normalized p ∧
    ∃ ε > 0, ∀ q : Fin n → ℝ,
      is_equilibrium q → is_normalized q → dist p q < ε → q = p

-- The local uniqueness property holds for an economy if every normalized equilibrium
-- price vector is locally isolated.