import Mathlib

variable {R G H : Type*} [CommRing R] [AddCommMonoid G] [AddCommMonoid H] [Module R G] [Module R H]

def linearTransformationsSubmodule : Submodule R (G → H) :=
  { carrier := Set.range (fun (f : G →ₗ[R] H) => (f : G → H))
    zero_mem' := ⟨0, rfl⟩
    add_mem' := by
      rintro _ _ ⟨f, rfl⟩ ⟨g, rfl⟩
      exact ⟨f + g, rfl⟩
    smul_mem' := by
      rintro r _ ⟨f, rfl⟩
      exact ⟨r • f, rfl⟩ }