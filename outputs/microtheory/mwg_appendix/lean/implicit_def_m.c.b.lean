import Mathlib
open Topology

def MWG.IsQuasiconvex {E : Type*} [AddCommMonoid E] [Module ℝ E] (s : Set E) (f : E → ℝ) : Prop :=
  Convex ℝ s ∧ ∀ t : ℝ, ∀ x ∈ s, ∀ y ∈ s,
    f x ≤ t → f y ≤ t → ∀ a b : ℝ, 0 ≤ a → 0 ≤ b → a + b = 1 → f (a • x + b • y) ≤ t