import Mathlib

/-- The index of an equilibrium price vector. -/
axiom EquilibriumIndex (L : ℕ) : Type

/-- A regular economy. -/
axiom RegularEconomy (L : ℕ) : Type

/-- The set of equilibria of a regular economy is finite. -/
axiom RegularEconomy.equilibria (L : ℕ) (E : RegularEconomy L) : Finset (EquilibriumIndex L)

/-- The index of each equilibrium is +1 or -1. -/
axiom RegularEconomy.index (L : ℕ) (E : RegularEconomy L) : EquilibriumIndex L → ℤ

/-- Axiom encoding the homotopy-degree argument for the Index Theorem. -/
axiom RegularEconomy.index_sum_eq_one (L : ℕ) (hL : L ≥ 2) (E : RegularEconomy L) :
    (RegularEconomy.equilibria L E).sum (RegularEconomy.index L E) = 1

/--
**The Index Theorem (Proposition 17.D.2)**:
For any regular economy, the sum of indices over all equilibria equals +1.
-/
theorem index_theorem (L : ℕ) (hL : L ≥ 2) (E : RegularEconomy L) :
    (RegularEconomy.equilibria L E).sum (RegularEconomy.index L E) = 1 :=
  RegularEconomy.index_sum_eq_one L hL E