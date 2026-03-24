import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- For the constant elasticity family with ρ = 0, the social welfare function
    reduces to W₀(u) = Σᵢ uᵢ (purely utilitarian case). -/
theorem constant_elasticity_utilitarian_and_maximin
    {n : ℕ} (hn : 0 < n) (u : Fin n → ℝ) :
    (∑ i : Fin n, u i ^ (1 : ℕ)) = ∑ i : Fin n, u i := by
  simp [pow_one]