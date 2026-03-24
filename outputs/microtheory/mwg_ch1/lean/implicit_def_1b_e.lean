import Mathlib

def IsOrdinalProperty {X : Type*} (P : (X → ℝ) → Prop) : Prop :=
  ∀ (u : X → ℝ) (f : ℝ → ℝ), StrictMono f → (P u ↔ P (f ∘ u))