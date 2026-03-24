import Mathlib

theorem quotient_group_abelian {G : Type u} [CommGroup G] (N : Subgroup G) : ∀ a b : G ⧸ N, a * b = b * a := by
  intro a b
  refine QuotientGroup.induction_on a fun x => ?_
  refine QuotientGroup.induction_on b fun y => ?_
  simp only [QuotientGroup.mk_mul, mul_comm]