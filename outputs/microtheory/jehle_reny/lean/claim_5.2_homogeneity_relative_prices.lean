import Mathlib

open Finset BigOperators
open Topology -- For completeness, although not directly used in this proof

-- Definition 5.5: A Walrasian equilibrium
def IsWalrasianEquilibrium {n : ℕ} (z : (Fin n → ℝ) → (Fin n → ℝ)) (p_star : Fin n → ℝ) :=
  (∀ i, 0 < p_star i) ∧ (z p_star = 0)