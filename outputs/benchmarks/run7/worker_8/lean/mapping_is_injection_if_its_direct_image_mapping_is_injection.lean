import Mathlib

theorem Function.Injective.of_direct_image_injective {S T : Type _} (f : S → T)
    (h_inj : Function.Injective (Set.image f)) : Function.Injective f := by
  intro x₁ x₂ h
  have h_image_eq : f '' ({x₁} : Set S) = f '' ({x₂} : Set S) := by
    rw [Set.image_singleton, Set.image_singleton, h]
  have h_set_eq : ({x₁} : Set S) = ({x₂} : Set S) := h_inj h_image_eq
  exact Set.singleton_injective h_set_eq