import Mathlib

noncomputable def MWG.BellmanOperator
    (A : Set ℝ) (u : ℝ → ℝ → ℝ) (δ : ℝ) (v : ℝ → ℝ) (z : ℝ) : ℝ :=
  ⨆ z' ∈ A, (u z z' + δ * v z')

/-- The Bellman equation (optimality principle): `v` satisfies the Bellman equation
    if `v(z) = max_{z' ∈ A} [u(z,z') + δ·v(z')]` for every `z ∈ A`. -/
def MWG.SatisfiesBellmanEquation
    (A : Set ℝ) (u : ℝ → ℝ → ℝ) (δ : ℝ) (v : ℝ → ℝ) : Prop :=
  ∀ z ∈ A, v z = MWG.BellmanOperator A u δ v z