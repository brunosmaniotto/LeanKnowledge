import Mathlib

open Finset

theorem Proposition_21D1
    {I : Type*} [Fintype I] [DecidableEq I]
    (prefersMedian : I → Prop) [DecidablePred prefersMedian]
    (prefersOther : I → Prop) [DecidablePred prefersOther]
    (disjoint : ∀ i, ¬(prefersMedian i ∧ prefersOther i))
    (hMedian : 2 * (univ.filter prefersMedian).card ≥ Fintype.card I)
    : (univ.filter prefersOther).card ≤ (univ.filter prefersMedian).card := by
  have hDisj : Disjoint (univ.filter prefersMedian) (univ.filter prefersOther) := by
    rw [Finset.disjoint_filter]
    exact fun i _ h1 h2 => disjoint i ⟨h1, h2⟩
  have hUnion : (univ.filter prefersMedian ∪ univ.filter prefersOther).card =
      (univ.filter prefersMedian).card + (univ.filter prefersOther).card :=
    card_union_of_disjoint hDisj
  have hBound : (univ.filter prefersMedian).card + (univ.filter prefersOther).card ≤ Fintype.card I := by
    rw [← hUnion, ← card_univ]
    exact card_le_card (union_subset (filter_subset _ _) (filter_subset _ _))
  omega