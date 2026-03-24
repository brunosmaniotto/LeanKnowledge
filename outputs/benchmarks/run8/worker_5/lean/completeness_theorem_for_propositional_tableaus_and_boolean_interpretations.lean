import Mathlib

theorem completeness_theorem (WFF : Type) (models_BI : Set WFF → WFF → Prop) (PT_proves : Set WFF → WFF → Prop)
    (extended_completeness : ∀ (H : Set WFF) (A : WFF), models_BI H A → PT_proves H A)
    (A : WFF) (h : models_BI ∅ A) : PT_proves ∅ A :=
  extended_completeness ∅ A h