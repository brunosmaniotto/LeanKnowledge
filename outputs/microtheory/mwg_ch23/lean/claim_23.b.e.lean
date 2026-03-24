import Mathlib
open Topology

/-- A mechanism combined with type spaces, a prior density, and Bernoulli utility functions
    defines a Bayesian game of incomplete information. We formalize this as a structure
    construction: given the components, we produce a Bayesian game. -/
theorem bayesian_game_from_mechanism
    {I : Type*} [Fintype I] [DecidableEq I]
    {Outcome : Type*}
    (S : I → Type*)           -- strategy sets S_i
    (Θ : I → Type*)           -- type spaces Θ_i
    (g : (∀ i, S i) → Outcome)  -- outcome function g(s₁,...,s_I)
    (u : I → Outcome → (∀ i, Θ i) → ℝ) -- utility functions u_i(outcome, θ)
    : ∃ (û : I → (∀ i, S i) → (∀ i, Θ i) → ℝ),
      ∀ i s θ, û i s θ = u i (g s) θ := by
  exact ⟨fun i s θ => u i (g s) θ, fun _ _ _ => rfl⟩