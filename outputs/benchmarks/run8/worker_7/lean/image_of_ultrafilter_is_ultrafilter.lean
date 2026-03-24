import Mathlib

theorem image_of_ultrafilter_is_ultrafilter {X Y : Type*} (f : X → Y) (ℱ : Ultrafilter X) :
    ∃ (u : Ultrafilter Y), (u : Filter Y) = Filter.map f (ℱ : Filter X) :=
  ⟨ℱ.map f, rfl⟩