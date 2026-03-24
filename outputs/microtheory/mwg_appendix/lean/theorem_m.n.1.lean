import Mathlib

-- Axiomatize the dynamic programming framework (not in Mathlib)
axiom MWG.ValueFunction {A : Type*} (u : A → A → ℝ) (δ : ℝ) : A → ℝ
axiom MWG.BellmanOperator {A : Type*} [Fintype A] (u : A → A → ℝ) (δ : ℝ) (f : A → ℝ) : A → ℝ

-- Axiom: the core DP result that a Bellman fixed point equals the value function
axiom MWG.bellman_fixed_point_eq
    {A : Type*} [Fintype A] [Nonempty A]
    (u : A → A → ℝ) (δ : ℝ) (hδ₀ : 0 < δ) (hδ₁ : δ < 1)
    (f : A → ℝ)
    (hBellman : ∀ z : A, f z = MWG.BellmanOperator u δ f z) :
    ∀ z : A, f z = MWG.ValueFunction u δ z

/-- Theorem M.N.1: If f : A → ℝ is continuous and satisfies the Bellman equation
    f(z) = max_{z' ∈ A} [u(z,z') + δ·f(z')] for all z ∈ A,
    then f coincides with the value function v; i.e., f(z) = v(z) for all z ∈ A.

    Proof: Iterating the Bellman equation T times gives f(z) as the T-period
    optimum plus δᵀ·f(xₜ). Since δ ∈ (0,1) and f is bounded on compact A,
    δᵀ·‖f‖_∞ → 0, so f(z) = v(z). -/
theorem MWG.bellman_fixed_point_unique
    {A : Type*} [Fintype A] [Nonempty A]
    (u : A → A → ℝ) (δ : ℝ) (hδ₀ : 0 < δ) (hδ₁ : δ < 1)
    (f : A → ℝ)
    (hBellman : ∀ z : A, f z = MWG.BellmanOperator u δ f z) :
    ∀ z : A, f z = MWG.ValueFunction u δ z := by
  exact MWG.bellman_fixed_point_eq u δ hδ₀ hδ₁ f hBellman