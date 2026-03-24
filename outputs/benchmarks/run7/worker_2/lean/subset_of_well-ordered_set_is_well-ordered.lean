import Mathlib

open Set

/-- Every subset (including non-empty ones) of a well-ordered set is well-ordered. -/
theorem subset_wellOrdered {α : Type*} [LinearOrder α] [WellFoundedLT α] (T : Set α) :
    WellFoundedLT (Subtype T) := by
  -- The instance for subtypes already exists in Mathlib
  infer_instance