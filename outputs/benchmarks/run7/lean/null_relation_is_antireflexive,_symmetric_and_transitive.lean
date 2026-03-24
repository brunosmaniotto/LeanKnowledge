import Mathlib

theorem null_relation_antireflexive_symmetric_transitive {α : Type} (S : Set α) (hS : S.Nonempty) 
    (R : Set (α × α)) (hR : R = ∅) :
    let rel : α → α → Prop := fun x y => (x, y) ∈ R
    Irreflexive rel ∧ Symmetric rel ∧ Transitive rel := by
  intro rel
  have irr : Irreflexive rel := by
    intro x
    simp [rel, hR]
  have symm : Symmetric rel := by
    intro x y h
    exfalso
    simp [rel, hR] at h
  have trans : Transitive rel := by
    intro x y z hxy hyz
    exfalso
    simp [rel, hR] at hxy
  exact ⟨irr, symm, trans⟩