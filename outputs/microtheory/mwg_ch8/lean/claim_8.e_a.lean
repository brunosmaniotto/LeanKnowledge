import Mathlib
open Topology

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {Θ : I → Type*} {A : I → Type*}
variable [∀ i, Fintype (Θ i)] [∀ i, Fintype (A i)]

def PointwiseOptimal (u : ∀ i, Θ i → A i → ℝ) (s : ∀ i, Θ i → A i) : Prop :=
  ∀ i, ∀ θ : Θ i, ∀ a : A i, u i θ (s i θ) ≥ u i θ a