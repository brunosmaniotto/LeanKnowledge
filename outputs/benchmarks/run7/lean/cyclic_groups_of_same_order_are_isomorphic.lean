import Mathlib

theorem cyclicGroupsOfSameOrderAreIsomorphic (G₁ G₂ : Type*) [Group G₁] [Group G₂] [Fintype G₁] [Fintype G₂]
    [IsCyclic G₁] [IsCyclic G₂] (hcard : Fintype.card G₁ = Fintype.card G₂) : Nonempty (G₁ ≃* G₂) :=
  ⟨mulEquivOfCyclicCardEq (by rw [Nat.card_eq_fintype_card, Nat.card_eq_fintype_card, hcard])⟩