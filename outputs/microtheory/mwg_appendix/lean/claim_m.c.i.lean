import Mathlib

open Set

variable {E : Type*} [AddCommMonoid E] [Module ℝ E]

def IsQuasiconcave (f : E → ℝ) : Prop :=
  ∀ α : ℝ, Convex ℝ {x | α ≤ f x}