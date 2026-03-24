import Mathlib
open Finset

theorem claim_8_1_3_two_policies
    {Policy : Type*} [DecidableEq Policy]
    (menu : Finset Policy)
    (hmenu : menu.Nonempty)
    (choice_type1 : Policy)
    (choice_type2 : Policy)
    (h1 : choice_type1 ∈ menu)
    (h2 : choice_type2 ∈ menu) :
    ∃ (reduced : Finset Policy),
      reduced ⊆ menu ∧
      reduced.card ≤ 2 ∧
      choice_type1 ∈ reduced ∧
      choice_type2 ∈ reduced := by
  refine ⟨{choice_type1, choice_type2}, ?_, ?_, ?_, ?_⟩
  · intro x hx
    simp only [mem_insert, mem_singleton] at hx
    rcases hx with rfl | rfl <;> assumption
  · calc ({choice_type1, choice_type2} : Finset Policy).card
        ≤ ({choice_type2} : Finset Policy).card + 1 := card_insert_le _ _
      _ = 1 + 1 := by simp [card_singleton]
      _ = 2 := by norm_num
  · exact mem_insert_self _ _
  · simp