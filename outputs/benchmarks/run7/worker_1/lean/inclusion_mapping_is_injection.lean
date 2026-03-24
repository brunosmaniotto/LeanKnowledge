import Mathlib

variable {α : Type*} {S T : Set α} (h : S ⊆ T)

/-- The inclusion map from `S` to `T` when `S ⊆ T`. -/
def inclusion : S → T := Set.inclusion h