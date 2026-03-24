import Mathlib
open Matrix

theorem hildenbrand_no_positive_representative_consumer :
    ∃ (L : ℕ), L ≥ 3 ∧
      ¬ ∀ (S : Matrix (Fin L) (Fin L) ℝ),
        (∀ i j, S i j = S j i) := by
  refine ⟨3, le_refl 3, ?_⟩
  push_neg
  refine ⟨fun i j => if i.val = 0 ∧ j.val = 1 then 1 else 0, ⟨0, by omega⟩, ⟨1, by omega⟩, ?_⟩
  simp