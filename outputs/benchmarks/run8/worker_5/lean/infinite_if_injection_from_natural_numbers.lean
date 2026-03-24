import Mathlib

open Set

theorem Infinite_if_Injection_from_Natural_Numbers {α : Type*} (S : Set α) (φ : ℕ → S) (hφ : Function.Injective φ) :
    Set.Infinite S := by
  let f : ℕ → α := fun n => (φ n).val
  have hf_inj : Function.Injective f := by
    intro x y h
    have h_eq : φ x = φ y := Subtype.eq h
    exact hφ h_eq
  have h_range_infinite : Set.Infinite (range f) :=
    Set.infinite_range_of_injective hf_inj
  have h_sub : range f ⊆ S := by
    rintro x ⟨n, rfl⟩
    exact (φ n).property
  exact Set.Infinite.mono h_sub h_range_infinite