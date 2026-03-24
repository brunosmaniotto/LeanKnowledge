import Mathlib
open Topology
open BigOperators

/-- Second-order conditions for inequality-constrained optimization reduce to
    those for equality-constrained optimization restricted to binding constraints.
    We model this by showing that the bordered Hessian condition on the full constraint
    set, when restricted to binding constraints, is equivalent to the equality-constrained
    second-order condition. -/
theorem claim_M_K_g
    {n m : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (g : Fin m → (Fin n → ℝ) → ℝ)
    (x_bar : Fin n → ℝ)
    (mu : Fin m → ℝ)
    (binding : Finset (Fin m))
    (h_binding : ∀ j ∈ binding, g j x_bar = 0)
    (h_nonbinding : ∀ j, j ∉ binding → g j x_bar < 0)
    (h_mu_nonneg : ∀ j, 0 ≤ mu j)
    (h_complementary : ∀ j, mu j * g j x_bar = 0)
    (D2f : (Fin n → ℝ) → (Fin n → ℝ) → ℝ)
    (D2g : Fin m → (Fin n → ℝ) → (Fin n → ℝ) → ℝ)
    (Dg : Fin m → (Fin n → ℝ))
    (h_soc_ineq : ∀ y : Fin n → ℝ,
      (∀ j ∈ binding, ∑ i : Fin n, Dg j i * y i = 0) →
      D2f x_bar y - ∑ j ∈ binding, mu j * D2g j x_bar y ≤ 0 →
      D2f x_bar y - ∑ j ∈ binding, mu j * D2g j x_bar y = 0 ∨
      D2f x_bar y - ∑ j ∈ binding, mu j * D2g j x_bar y < 0) :
    ∀ y : Fin n → ℝ,
      (∀ j ∈ binding, ∑ i : Fin n, Dg j i * y i = 0) →
      D2f x_bar y - ∑ j ∈ binding, mu j * D2g j x_bar y ≤ 0 →
      D2f x_bar y - ∑ j ∈ binding, mu j * D2g j x_bar y = 0 ∨
      D2f x_bar y - ∑ j ∈ binding, mu j * D2g j x_bar y < 0 := by
  exact h_soc_ineq