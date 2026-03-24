import Mathlib

theorem claim_1_2_a {X : Type*}
    (R : X → X → Prop)
    (hcomp : ∀ x y : X, R x y ∨ R y x)
    (htrans : ∀ x y z : X, R x y → R y z → R x z) :
    ∀ (l : List X), l ≠ [] → ∃ m ∈ l, ∀ x ∈ l, R m x := by
  have hrefl : ∀ x, R x x := fun x => (hcomp x x).elim id id
  intro l hl
  induction l with
  | nil => contradiction
  | cons a t ih =>
    by_cases ht : t = []
    · subst ht
      exact ⟨a, by simp, fun x hx => by simp at hx; subst hx; exact hrefl _⟩
    · obtain ⟨m, hmt, hm⟩ := ih ht
      rcases hcomp a m with ham | hma
      · exact ⟨a, by simp, fun x hx => by
          simp only [List.mem_cons] at hx
          rcases hx with rfl | hxt
          · exact hrefl _
          · exact htrans a m x ham (hm x hxt)⟩
      · exact ⟨m, List.mem_cons.mpr (Or.inr hmt), fun x hx => by
          simp only [List.mem_cons] at hx
          rcases hx with rfl | hxt
          · exact hma
          · exact hm x hxt⟩