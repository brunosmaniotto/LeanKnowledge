import Mathlib

theorem quotient_group_of_ideal_properties (R : Type) [Ring R] (J : Ideal R) :
    (∀ a : R ⧸ J.toAddSubgroup, ∃ x : R, (QuotientAddGroup.mk x : R ⧸ J.toAddSubgroup) = a) ∧
    (∀ x y : R, (QuotientAddGroup.mk (x + y) : R ⧸ J.toAddSubgroup) = (QuotientAddGroup.mk x : R ⧸ J.toAddSubgroup) + (QuotientAddGroup.mk y : R ⧸ J.toAddSubgroup)) ∧
    ((QuotientAddGroup.mk 0 : R ⧸ J.toAddSubgroup) = (0 : R ⧸ J.toAddSubgroup)) ∧
    (∀ x : R, (QuotientAddGroup.mk (-x) : R ⧸ J.toAddSubgroup) = -(QuotientAddGroup.mk x : R ⧸ J.toAddSubgroup)) := by
  constructor
  · exact QuotientAddGroup.mk_surjective
  constructor
  · intros x y
    exact (QuotientAddGroup.mk_add J.toAddSubgroup x y).symm
  constructor
  · exact (QuotientAddGroup.mk_zero J.toAddSubgroup).symm
  · intro x
    exact (QuotientAddGroup.mk_neg J.toAddSubgroup x).symm