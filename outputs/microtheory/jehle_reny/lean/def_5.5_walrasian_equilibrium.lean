import Mathlib
open Topology

/-- Definition 5.5: A Walrasian equilibrium is a strictly positive price vector p*
    such that the excess demand z(p*) = 0. -/
def IsWalrasianEquilibrium {n : ℕ} (z : (Fin n → ℝ) → (Fin n → ℝ)) (p : Fin n → ℝ) : Prop :=
  (∀ i, 0 < p i) ∧ z p = 0