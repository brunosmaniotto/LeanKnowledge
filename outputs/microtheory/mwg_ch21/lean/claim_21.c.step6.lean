import Mathlib
open Topology

variable {I : Type*} [Fintype I] [DecidableEq I]

variable (Decisive : Finset I → Prop)

theorem arrow_step6
    (pareto : ¬ Decisive ∅)
    (step5 : ∀ S : Finset I, Decisive S ∨ Decisive (Finset.univ \ S))
    (mono : ∀ A B : Finset I, Decisive A → Decisive B → Decisive (A ∩ B))
    (S T : Finset I)
    (hS : Decisive S)
    (hST : S ⊆ T) :
    Decisive T := by
  rcases step5 T with hT | hIT
  · exact hT
  · exfalso
    have h := mono S (Finset.univ \ T) hS hIT
    have hempty : S ∩ (Finset.univ \ T) = ∅ := by
      ext x
      simp only [Finset.mem_inter, Finset.mem_sdiff, Finset.mem_univ, true_and]
      constructor
      · rintro ⟨hxS, hxT⟩
        exact absurd (hST hxS) hxT
      · simp
    rw [hempty] at h
    exact pareto h