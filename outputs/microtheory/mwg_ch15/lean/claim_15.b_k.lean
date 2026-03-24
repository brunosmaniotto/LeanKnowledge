import Mathlib
open BigOperators

-- Formalization of Claim 15.B.k: Lump-sum transfers to Pareto optimal allocation
-- yield a no-trade Walrasian equilibrium; strict convexity implies uniqueness.

universe u

-- We axiomatize the economic environment
variable {I : Type*} [Fintype I] [DecidableEq I]  -- consumers
variable {L : ℕ}  -- number of commodities (dimension)
variable (hL : 0 < L)

-- Commodity bundles as functions from Fin L to ℝ
abbrev Bundle (L : ℕ) := Fin L → ℝ

-- Economic primitives (axiomatized)
variable (preference : I → Bundle L → Bundle L → Prop)  -- strict preference
variable (endowment : I → Bundle L)  -- initial endowments
variable (xStar : I → Bundle L)  -- target Pareto optimal allocation

-- Pareto optimality of x*
variable (hPareto : ∀ (y : I → Bundle L),
    (∀ i, ∃ j, preference j (y j) (xStar j)) →
    ∃ i, preference i (xStar i) (y i))

-- Feasibility: x* uses the same total resources as endowments
variable (hFeasible : ∀ l : Fin L, ∑ i, xStar i l = ∑ i, endowment i l)

-- All commodities are transferable (lump-sum transfers are possible)
variable (transferable : Prop)
variable (hTransferable : transferable)

-- Walrasian equilibrium predicate at a given endowment
variable (isWalrasianEq : (I → Bundle L) → (I → Bundle L) → Prop)

-- No-trade equilibrium: allocation equals endowment
def noTradeEq (alloc endow : I → Bundle L) : Prop :=
  ∀ i l, alloc i l = endow i l

-- Strict convexity of preferences