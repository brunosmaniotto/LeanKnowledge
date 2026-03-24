import Mathlib

/-
A Walrasian equilibrium is a special case of a price equilibrium with transfers,
where wealth is determined by endowments and profit shares:
  w_i = p · ω_i + Σ_j θ_{ij} (p · y_j*)
-/

open Finset BigOperators
open BigOperators

variable {I J : Type*} [Fintype I] [Fintype J] [DecidableEq I] [DecidableEq J]
variable (L : ℕ) -- number of commodities

/-- A price equilibrium with transfers: each consumer i has wealth w_i. -/
structure PriceEquilWithTransfers (I J : Type*) [Fintype I] [Fintype J] where
  p : Fin L → ℝ                    -- price vector
  x : I → Fin L → ℝ               -- consumption allocation
  y : J → Fin L → ℝ               -- production plans
  w : I → ℝ                        -- wealth levels (transfers)

/-- A Walrasian equilibrium: wealth derived from endowments and profit shares. -/
structure WalrasianEquilibrium (I J : Type*) [Fintype I] [Fintype J] where
  p : Fin L → ℝ
  x : I → Fin L → ℝ
  y : J → Fin L → ℝ
  ω : I → Fin L → ℝ               -- endowments
  θ : I → J → ℝ                    -- profit shares

noncomputable def walrasianWealth (we : WalrasianEquilibrium L I J) (i : I) : ℝ :=
  ∑ l, we.p l * we.ω i l + ∑ j, we.θ i j * ∑ l, we.p l * we.y j l

/-- Convert a Walrasian equilibrium to a price equilibrium with transfers
    by setting w_i = p · ω_i + Σ_j θ_{ij} (p · y_j*). -/
noncomputable def WalrasianEquilibrium.toPEWT (we : WalrasianEquilibrium L I J) :
    PriceEquilWithTransfers L I J where
  p := we.p
  x := we.x
  y := we.y
  w := fun i => walrasianWealth L we i

/-- The Walrasian equilibrium embeds into price equilibria with transfers:
    the wealth assigned equals endowment value plus profit shares. -/
theorem walrasian_is_pewt (we : WalrasianEquilibrium L I J) (i : I) :
    (we.toPEWT L).w i = ∑ l, we.p l * we.ω i l + ∑ j, we.θ i j * ∑ l, we.p l * we.y j l := by
  simp [WalrasianEquilibrium.toPEWT, walrasianWealth]