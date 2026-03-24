import Mathlib
open Topology

theorem claim_21_D_i
    {I : Type*} [Fintype I] [DecidableEq I]
    (hI : Odd (Fintype.card I))
    (prefers_x : I → Bool) :
    (Finset.univ.filter (fun i => prefers_x i = true)).card > Fintype.card I / 2 ∨
    (Finset.univ.filter (fun i => prefers_x i = false)).card > Fintype.card I / 2 := by
  set A := Finset.univ.filter (fun i : I => prefers_x i = true)
  set B := Finset.univ.filter (fun i : I => prefers_x i = false)
  have hdisj : Disjoint A B := by
    rw [Finset.disjoint_left]
    intro x hxA hxB
    simp only [A, B, Finset.mem_filter, Finset.mem_univ, true_and] at hxA hxB
    rw [hxA] at hxB
    exact Bool.noConfusion hxB
  have hunion : A ∪ B = Finset.univ := by
    ext x
    simp only [A, B, Finset.mem_union, Finset.mem_filter, Finset.mem_univ, true_and]
    constructor
    · intro; trivial
    · intro _
      cases h : prefers_x x
      · exact Or.inr rfl
      · exact Or.inl rfl
  have hcard : A.card + B.card = Fintype.card I := by
    rw [← Finset.card_union_of_disjoint hdisj, hunion, Finset.card_univ]
  obtain ⟨k, hk⟩ := hI
  omega