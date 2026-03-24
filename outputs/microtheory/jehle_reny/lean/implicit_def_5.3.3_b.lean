import Mathlib

/-- A price vector `p` is a Walrasian equilibrium in a production economy with `L` commodities
    and aggregate excess demand function `z` if `p ≫ 0` and `z(p) = 0` (all markets clear). -/
def IsWalrasianEquilibriumPrice (L : ℕ) (z : (Fin L → ℝ) → (Fin L → ℝ)) (p : Fin L → ℝ) : Prop :=
  (∀ i, 0 < p i) ∧ z p = 0