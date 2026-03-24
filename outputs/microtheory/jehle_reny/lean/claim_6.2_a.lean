import Mathlib
open Topology

theorem claim_6_2_a {X : Type*} [Fintype X] [DecidableEq X]
    (R : X → X → Prop) [DecidableRel R]
    (hcomp : ∀ x y : X, R x y ∨ R y x)
    (htrans : ∀ x y z : X, R x y → R y z → R x z) :
    ∀ S : Finset X, S.Nonempty → ∃ x ∈ S, ∀ y ∈ S, R x y := by
  have hrefl : ∀ x : X, R x x := fun x => (hcomp x x).elim id id
  intro S hS
  suffices h : ∀ n : ℕ, ∀ T : Finset X, T.card = n → T.Nonempty →
      ∃ x ∈ T, ∀ y ∈ T, R x y from h S.card S rfl hS
  intro n
  induction n with
  | zero =>
    intro T hT hne
    simp [Finset.card_eq_zero.mp hT] at hne
  | succ k ih =>
    intro T hcard hne
    obtain ⟨elem, helem⟩ := hne
    by_cases hrest : (T.erase elem).Nonempty
    · have hcard_erase : (T.erase elem).card = k := by
        rw [Finset.card_erase_of_mem helem]; omega
      obtain ⟨best, hbest_mem, hbest⟩ := ih (T.erase elem) hcard_erase hrest
      have hbest_in_T : best ∈ T := (Finset.mem_erase.mp hbest_mem).2
      rcases hcomp elem best with h1 | h2
      · refine ⟨elem, helem, fun y hy => ?_⟩
        by_cases hyeq : y = elem
        · rw [hyeq]; exact hrefl elem
        · exact htrans elem best y h1 (hbest y (Finset.mem_erase.mpr ⟨hyeq, hy⟩))
      · refine ⟨best, hbest_in_T, fun y hy => ?_⟩
        by_cases hyeq : y = elem
        · rw [hyeq]; exact h2
        · exact hbest y (Finset.mem_erase.mpr ⟨hyeq, hy⟩)
    · refine ⟨elem, helem, fun y hy => ?_⟩
      have hyeq : y = elem := by
        by_contra hne_eq
        exact hrest ⟨y, Finset.mem_erase.mpr ⟨hne_eq, hy⟩⟩
      rw [hyeq]; exact hrefl elem