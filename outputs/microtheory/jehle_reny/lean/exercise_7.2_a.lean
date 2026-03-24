import Mathlib

open Finset Function
open Topology

theorem exercise_7_2_a {S : Type*} [DecidableEq S] [Fintype S]
    (elim : Finset S → Finset S)
    (h_sub : ∀ s, elim s ⊆ s) :
    (∀ t : ℕ, elim^[t + 1] Finset.univ ⊆ elim^[t] Finset.univ) ∧
    (∃ T : ℕ, ∀ t, T ≤ t → elim^[t] Finset.univ = elim^[T] Finset.univ) := by
  have h_nested : ∀ t, elim^[t + 1] Finset.univ ⊆ elim^[t] Finset.univ := fun t => by
    rw [iterate_succ_apply']
    exact h_sub _
  refine ⟨h_nested, ?_⟩
  have key : ∃ T, elim^[T + 1] Finset.univ = elim^[T] Finset.univ := by
    by_contra hall
    push_neg at hall
    have h_strict : ∀ t, (elim^[t + 1] Finset.univ).card < (elim^[t] Finset.univ).card := by
      intro t
      exact lt_of_le_of_ne (card_le_card (h_nested t))
        (fun heq => hall t (eq_of_subset_of_card_le (h_nested t) heq.symm.le))
    have h_bound : ∀ t, (elim^[t] Finset.univ).card + t ≤ Fintype.card S := by
      intro t
      induction t with
      | zero => simp [card_univ]
      | succ n ih => have := h_strict n; omega
    have := h_bound (Fintype.card S + 1)
    omega
  obtain ⟨T, hT⟩ := key
  exact ⟨T, fun t ht => by
    induction ht with
    | refl => rfl
    | step _ ih =>
      rw [iterate_succ_apply', ih, ← iterate_succ_apply' elim T Finset.univ]
      exact hT⟩