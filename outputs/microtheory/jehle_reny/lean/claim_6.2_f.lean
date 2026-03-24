import Mathlib
open Finset BigOperators

/-- A "virtual dictator" — decisive on all pairs except one — is not excluded
    by the non-dictatorship condition D, which only rules out full dictators. -/
theorem virtual_dictator_satisfies_nondictatorship :
    ∃ (F : (Fin 2 → Fin 3 → Fin 3 → Prop) → Fin 3 → Fin 3 → Prop),
      -- Agent 0 is decisive on all pairs except (0,1)
      (∀ profile : Fin 2 → Fin 3 → Fin 3 → Prop,
        ∀ a b : Fin 3, (a, b) ≠ (0, 1) → profile 0 a b → F profile a b) ∧
      -- Agent 0 is NOT a full dictator
      (∃ profile : Fin 2 → Fin 3 → Fin 3 → Prop,
        ∃ a b : Fin 3, profile 0 a b ∧ ¬ F profile a b) := by
  refine ⟨fun profile a b =>
    if a = 0 ∧ b = 1 then profile 1 a b else profile 0 a b, ?_, ?_⟩
  · intro profile a b hab h0
    have hne : ¬(a = 0 ∧ b = 1) := by rintro ⟨rfl, rfl⟩; exact hab rfl
    simp [hne, h0]
  · exact ⟨fun i _ _ => i = 0, 0, 1, rfl, by decide⟩