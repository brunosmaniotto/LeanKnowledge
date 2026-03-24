import Mathlib.Order.WellFounded
open Set

theorem wellFounded_iff_no_descending_seq (S : Type*) (r : S → S → Prop) :
    WellFounded r ↔ ¬ ∃ (a : ℕ → S), ∀ n, r (a (n + 1)) (a n) := by
  constructor
  · intro h hseq
    rcases hseq with ⟨a, ha⟩
    have hne : (Set.range a).Nonempty := ⟨a 0, ⟨0, rfl⟩⟩
    rcases h.has_min (Set.range a) hne with ⟨x, ⟨n, rfl⟩, hmin⟩
    have hrel : r (a (n + 1)) (a n) := ha n
    have hmem : a (n + 1) ∈ Set.range a := ⟨n + 1, rfl⟩
    exact hmin (a (n + 1)) hmem hrel
  · intro h
    by_contra hwf
    have : ∃ a0, ¬ Acc r a0 := by
      contrapose! hwf
      exact ⟨fun a => hwf a⟩
    rcases this with ⟨a0, ha0⟩
    have h_exists : ∀ a, ¬ Acc r a → ∃ b, r b a ∧ ¬ Acc r b := by
      intro a ha
      by_contra h'
      push_neg at h'
      exact ha (Acc.intro a h')
    let f : ℕ → { a // ¬ Acc r a } :=
      Nat.rec ⟨a0, ha0⟩ (fun n fn =>
        ⟨Classical.choose (h_exists fn.1 fn.2), (h_exists fn.1 fn.2).choose_spec.2⟩)
    let a : ℕ → S := fun n => (f n).1
    have ha_step : ∀ n, r (a (n + 1)) (a n) := by
      intro n
      exact (Classical.choose_spec (h_exists (a n) (f n).2)).1
    exact h ⟨a, ha_step⟩