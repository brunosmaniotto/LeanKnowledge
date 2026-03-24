import Mathlib

-- Axiomatize economic primitives for a pure exchange economy
variable {I : Type*} [Fintype I] {L : ℕ}

/-- An allocation assigns a consumption bundle to each agent -/
abbrev Allocation (I : Type*) (L : ℕ) := I → Fin L → ℝ

/-- An endowment profile assigns an endowment vector to each agent -/
abbrev Endowment (I : Type*) (L : ℕ) := I → Fin L → ℝ

/-- Predicate: allocation x is a Walrasian equilibrium allocation in the economy with endowments e -/
axiom IsWalrasianEquilibriumAllocation (I : Type*) [Fintype I] (L : ℕ) :
    Allocation I L → Endowment I L → Prop

/-- Definition 5.7: W(e) is the set of all Walrasian equilibrium allocations
    for an economy with endowment profile e. -/
def walrasianEquilibriumAllocations (I : Type*) [Fintype I] (L : ℕ)
    (e : Endowment I L) : Set (Allocation I L) :=
  {x | IsWalrasianEquilibriumAllocation I L x e}