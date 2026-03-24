import Mathlib

theorem Symmetry_of_Relations_is_Symmetric {S : Type} (R : Set (S × S)) 
    (h : ∀ ⦃x y : S⦄, (x, y) ∈ R → (y, x) ∈ R) (x y : S) : (x, y) ∈ R ↔ (y, x) ∈ R :=
  ⟨fun hxy => h hxy, fun hyx => h hyx⟩