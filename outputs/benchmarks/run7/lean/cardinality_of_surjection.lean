import Mathlib

lemma surjective_card_le {S T : Type*} [Fintype S] [Fintype T] (f : S → T) (hf : Function.Surjective f) : Fintype.card T ≤ Fintype.card S := by
  exact Fintype.card_le_of_surjective f hf