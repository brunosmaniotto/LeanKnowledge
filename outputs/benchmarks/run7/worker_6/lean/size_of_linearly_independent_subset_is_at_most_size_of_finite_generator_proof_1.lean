import Mathlib

open Set Cardinal Submodule

variable {R : Type u} [Field R] {V : Type v} [AddCommGroup V] [Module R V]

theorem size_of_linearly_independent_subset_is_at_most_size_of_finite_generator
    (L F : Set V)
    (hL : LinearIndependent R (fun x : L => (x : V)))
    (hF : span R F = ⊤)
    (hF_finite : F.Finite) :
    L.Finite ∧ #L ≤ #F := by
  haveI := hF_finite.fintype
  have card_le : #L ≤ Fintype.card F :=
    linearIndependent_le_span (fun x : L => (x : V)) hL F hF
  have hF_card : #F = Fintype.card F := by simp
  have hL_finite : L.Finite := by
    rw [← Cardinal.lt_aleph0_iff_set_finite]
    exact lt_of_le_of_lt card_le (nat_lt_aleph0 (Fintype.card F))
  exact ⟨hL_finite, card_le.trans_eq hF_card.symm⟩