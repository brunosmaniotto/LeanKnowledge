import Mathlib

universe u

variable {Θ X : Type*} {I : Type*} [Fintype I]

def ExPostEfficient_B (u : I → Θ → X → ℝ) (f : Θ → X) (feasible : Set X) : Prop :=
  ∀ θ, ∀ x ∈ feasible, (∀ i, u i θ x ≥ u i θ (f θ)) → (∀ i, u i θ x = u i θ (f θ))