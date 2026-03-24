import Mathlib

variable {S : Type*} [Fintype S]

noncomputable def C : Set S → ℝ := fun A => (A.ncard : ℝ)

theorem cardinality_is_additive (A B : Set S) (h : Disjoint A B) : C (A ∪ B) = C A + C B := by
  unfold C
  have hA : A.Finite := (Set.finite_univ (α := S)).subset (Set.subset_univ A)
  have hB : B.Finite := (Set.finite_univ (α := S)).subset (Set.subset_univ B)
  exact_mod_cast Set.ncard_union_eq h hA hB