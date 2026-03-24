import Mathlib

-- The welfare theorems apply to Arrow-Debreu equilibrium because it is
-- a special case of Walrasian equilibrium for contingent commodities.
-- We formalize this as: any property holding for all Walrasian equilibria
-- holds for Arrow-Debreu equilibria, given an embedding.

universe u

/-- An Arrow-Debreu equilibrium is a Walrasian equilibrium over contingent commodities. -/
theorem arrow_debreu_welfare_theorems
    {WalrasianEq : Type u}
    {ArrowDebreuEq : Type u}
    (embed : ArrowDebreuEq → WalrasianEq)
    (P : WalrasianEq → Prop)
    (welfare_theorem : ∀ w : WalrasianEq, P w)
    (ad : ArrowDebreuEq) :
    P (embed ad) :=
  welfare_theorem (embed ad)