import Mathlib

open Set

theorem well_ordered_induction {S : Type _} [LinearOrder S] [hwo : IsWellOrder S (· < ·)] {T : Set S}
    (h : ∀ s, (∀ t < s, t ∈ T) → s ∈ T) : T = Set.univ := by
  have H : ∀ s, s ∈ T := fun s => hwo.wf.induction s h
  exact Set.eq_univ_of_forall H