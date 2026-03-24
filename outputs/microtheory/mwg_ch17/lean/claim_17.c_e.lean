import Mathlib

-- Second Welfare Theorem as consequence of Proposition 17.C.1
-- Formalized as a logical deduction from axiomatized economic primitives

theorem second_welfare_theorem
    {I : Type*} [Fintype I]
    {Alloc Price : Type*}
    (isParetoOptimal : Alloc → Prop)
    (isWalrasianEquil : Price → Alloc → Prop)
    (preferred : I → Alloc → Alloc → Prop)
    (supportedByPrices : Price → Alloc → Prop)
    -- Proposition 17.C.1: existence of Walrasian equilibrium
    (prop17C1 : ∀ x : Alloc, isParetoOptimal x → ∃ p : Price, ∃ x' : Alloc,
      isWalrasianEquil p x' ∧ (∀ i : I, preferred i x' x))
    -- Pareto optimality + weak preference implies indifference
    (pareto_indiff : ∀ x x' : Alloc, isParetoOptimal x →
      (∀ i : I, preferred i x' x) → (∀ i : I, preferred i x x'))
    -- Indifference at equilibrium implies price support
    (indiff_support : ∀ (p : Price) (x x' : Alloc),
      isWalrasianEquil p x' → (∀ i : I, preferred i x x') →
      (∀ i : I, preferred i x' x) → supportedByPrices p x)
    (x : Alloc) (hpo : isParetoOptimal x) :
    ∃ p : Price, supportedByPrices p x := by
  obtain ⟨p, x', hequil, hpref⟩ := prop17C1 x hpo
  exact ⟨p, indiff_support p x x' hequil (pareto_indiff x x' hpo hpref) hpref⟩