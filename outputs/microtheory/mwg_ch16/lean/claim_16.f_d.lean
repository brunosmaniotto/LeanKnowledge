import Mathlib

variable {L I J : Type*} [Fintype L] [Fintype I] [Fintype J]

def ParetoFOC (Du : I → L → ℝ) (DF : J → L → ℝ)
    (α : I → ℝ) (β : J → ℝ) (μ : L → ℝ) : Prop :=
  (∀ i ℓ, Du i ℓ = α i * μ ℓ) ∧ (∀ j ℓ, DF j ℓ = β j * μ ℓ)