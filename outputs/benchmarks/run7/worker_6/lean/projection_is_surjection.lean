import Mathlib

open Set

variable {α β : Type*}

noncomputable def proj1 (S : Set α) (T : Set β) : S ×ˢ T → S :=
  fun p => ⟨p.1.1, p.2.left⟩

noncomputable def proj2 (S : Set α) (T : Set β) : S ×ˢ T → T :=
  fun p => ⟨p.1.2, p.2.right⟩

theorem proj1_surjective (S : Set α) (T : Set β) (hS : S.Nonempty) (hT : T.Nonempty) :
    Function.Surjective (proj1 S T) := by
  intro s
  rcases hT with ⟨b, hb⟩
  exact ⟨⟨(s.1, b), s.2, hb⟩, rfl⟩