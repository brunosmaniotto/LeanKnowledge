import Mathlib
open Topology

/-- Neither strict preference ≻ nor indifference ∼ is complete in general.
    We exhibit a preference relation on Fin 3 where elements 1 and 2 are
    incomparable under both ≻ and ∼. -/
theorem Claim_1_2_1_c :
    ∃ (pref : Fin 3 → Fin 3 → Prop),
      let strict := fun x y => pref x y ∧ ¬pref y x
      let indiff := fun x y => pref x y ∧ pref y x
      (∃ x y : Fin 3, ¬strict x y ∧ ¬strict y x) ∧
      (∃ x y : Fin 3, ¬indiff x y ∧ ¬indiff y x) := by
  -- Define pref where: 0 ≿ 1, 1 ≿ 0, 0 ≿ 2, but ¬(2 ≿ 0), ¬(1 ≿ 2), ¬(2 ≿ 1)
  refine ⟨fun x y => (x = 0 ∧ y = 1) ∨ (x = 1 ∧ y = 0) ∨ (x = 0 ∧ y = 2), ?_, ?_⟩
  · -- Strict preference is not complete: 1 and 2 are incomparable
    refine ⟨1, 2, ?_, ?_⟩
    · rintro ⟨h1, -⟩
      rcases h1 with ⟨h, -⟩ | ⟨-, h⟩ | ⟨h, -⟩ <;> simp at h
    · rintro ⟨h1, -⟩
      rcases h1 with ⟨h, -⟩ | ⟨h, -⟩ | ⟨-, h⟩ <;> simp at h
  · -- Indifference is not complete: 1 and 2 are incomparable
    refine ⟨1, 2, ?_, ?_⟩
    · rintro ⟨h1, -⟩
      rcases h1 with ⟨h, -⟩ | ⟨-, h⟩ | ⟨h, -⟩ <;> simp at h
    · rintro ⟨h1, -⟩
      rcases h1 with ⟨h, -⟩ | ⟨h, -⟩ | ⟨-, h⟩ <;> simp at h