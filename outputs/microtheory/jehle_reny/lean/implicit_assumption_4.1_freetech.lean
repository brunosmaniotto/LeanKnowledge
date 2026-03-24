import Mathlib

/-- Free access to technology: every firm faces the same technology set.
    No firm has proprietary technology — in particular, non-producing firms
    can access the technology of any currently producing firm. -/
def FreeAccessToTechnology {I : Type*} {Y : Type*} (tech : I → Set Y) : Prop :=
  ∀ i j : I, tech i = tech j