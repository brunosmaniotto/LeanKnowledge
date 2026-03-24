import Mathlib

open Function

theorem left_inverse_of_injective_is_surjective {S T : Type _} {f : S → T} {g : T → S}
    (hinj : Injective f) (hleft : g ∘ f = id) : Surjective g := by
  intro s
  refine ⟨f s, ?_⟩
  calc
    g (f s) = (g ∘ f) s := rfl
    _ = id s := by rw [hleft]
    _ = s := rfl