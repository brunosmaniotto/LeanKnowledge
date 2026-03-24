import Mathlib
open BigOperators
open Finset

/-- A discrete-time dynamic programming problem with N capital goods (MWG 20.D.8). -/
structure DynamicProgrammingProblem (N : ℕ) where
  returnFn : (Fin N → ℝ) → (Fin N → ℝ) → ℝ
  β : ℝ
  isFeasible : (Fin N → ℝ) → (Fin N → ℝ) → Prop

/-- A capital path is feasible for the problem starting from k₀. -/
def DynamicProgrammingProblem.IsFeasiblePath {N : ℕ} (P : DynamicProgrammingProblem N)
    (k₀ : Fin N → ℝ) (path : ℕ → (Fin N → ℝ)) : Prop :=
  path 0 = k₀ ∧ ∀ t, P.isFeasible (path t) (path (t + 1))

/-- The discounted return along a feasible path. -/
noncomputable def DynamicProgrammingProblem.discountedReturn {N : ℕ}
    (P : DynamicProgrammingProblem N) (path : ℕ → (Fin N → ℝ)) (T : ℕ) : ℝ :=
  ∑ t ∈ Finset.range T, P.β ^ t * P.returnFn (path t) (path (t + 1))

/-- The value function V(k): supremum of discounted returns over feasible paths
    starting from k₀ = k. Corresponds to MWG Definition 20.D.f. -/
noncomputable def DynamicProgrammingProblem.valueFunction {N : ℕ}
    (P : DynamicProgrammingProblem N) (k : Fin N → ℝ) : ℝ :=
  ⨆ (path : ℕ → (Fin N → ℝ)) (_ : P.IsFeasiblePath k path)
    (T : ℕ), P.discountedReturn path T

/-- The policy function ψ(k): the optimal next-period capital vector k₁
    when current capital is k. That is, ψ(k) ∈ ℝ^N gives the optimal
    investment levels at t = 1 given k₀ = k. -/
noncomputable def DynamicProgrammingProblem.policyFunction {N : ℕ}
    (P : DynamicProgrammingProblem N) (k : Fin N → ℝ) : Fin N → ℝ :=
  Classical.epsilon fun k₁ =>
    P.isFeasible k k₁ ∧
    P.valueFunction k = P.returnFn k k₁ + P.β * P.valueFunction k₁