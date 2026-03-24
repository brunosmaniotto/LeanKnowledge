import Mathlib

theorem claim_1_2_1_a {X : Type*}
    (R : X → X → Prop)
    (hcomp : ∀ x y : X, R x y ∨ R y x)
    (htrans : ∀ x y z : X, R x y → R y z → R x z) :
    ∀ (l : List X), l ≠ [] → ∃ m ∈ l, ∀ x ∈ l, R m x := by
  have hrefl : ∀ x, R x x := fun x => (hcomp x x).elim id id
  intro l hl
  induction l with
  | nil => contradiction
  | cons hd tl ih =>
    by_cases ht : tl = []
    · subst ht
      refine ⟨hd, List.mem_cons.mpr (Or.inl rfl), ?_⟩
      intro x hx
      rw [List.mem_cons] at hx
      rcases hx with rfl | hx
      · exact hrefl _
      · simp at hx
    · obtain ⟨m, hmt, hdom⟩ := ih ht
      rcases hcomp hd m with ham | hma
      · refine ⟨hd, List.mem_cons.mpr (Or.inl rfl), ?_⟩
        intro x hx
        rw [List.mem_cons] at hx
        rcases hx with rfl | hxt
        · exact hrefl _
        · exact htrans _ _ _ ham (hdom _ hxt)
      · refine ⟨m, List.mem_cons.mpr (Or.inr hmt), ?_⟩
        intro x hx
        rw [List.mem_cons] at hx
        rcases hx with rfl | hxt
        · exact hma
        · exact hdom _ hxt