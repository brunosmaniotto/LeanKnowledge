import Mathlib

theorem principle_of_counting (T : Type _) [Fintype T] (n : ℕ) (h : Fintype.card T = n) :
    ∀ (m : ℕ), n ≠ m → ¬ Nonempty (T ≃ Fin m) := by
  intro m hnm ⟨e⟩
  -- From the equivalence `e : T ≃ Fin m`, we get that the cardinality of T equals m
  have hcard : Fintype.card T = Fintype.card (Fin m) := Fintype.card_congr e
  have hcard_fin : Fintype.card (Fin m) = m := Fintype.card_fin m
  rw [hcard_fin] at hcard
  -- But we already know Fintype.card T = n, so n = m
  have : n = m := Eq.trans h.symm hcard
  exact hnm this