import Mathlib

open Set

theorem open_graph_implies_lhc
    {A Y : Type*} [TopologicalSpace A] [TopologicalSpace Y]
    (f : A → Set Y)
    (hopen : IsOpen {p : A × Y | p.2 ∈ f p.1}) :
    ∀ V : Set Y, IsOpen V → IsOpen {a : A | (f a ∩ V).Nonempty} := by
  intro V hV
  have heq : {a : A | (f a ∩ V).Nonempty} = Prod.fst '' ({p : A × Y | p.2 ∈ f p.1} ∩ univ ×ˢ V) := by
    ext a
    simp only [mem_setOf_eq, mem_image, Prod.exists, mem_inter_iff, mem_setOf_eq,
               mem_prod, mem_univ, true_and, Set.Nonempty]
    constructor
    · rintro ⟨y, hyf, hyV⟩
      exact ⟨a, y, ⟨hyf, hyV⟩, rfl⟩
    · rintro ⟨a', y, ⟨hyf, hyV⟩, ha⟩
      exact ⟨y, ha ▸ hyf, hyV⟩
  rw [heq]
  exact isOpenMap_fst _ (hopen.inter (isOpen_univ.prod hV))