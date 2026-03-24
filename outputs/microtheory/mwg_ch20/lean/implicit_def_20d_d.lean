import Mathlib

open BigOperators
open Finset

/-- The reduced planning problem (20.D.8) in the (N+1)-sector model. -/
structure ReducedPlanningProblem (N : ℕ) where
  δ : ℝ
  hδ_pos : 0 < δ
  hδ_lt_one : δ < 1
  u : (Fin N → ℝ) → (Fin N → ℝ) → ℝ
  A : Set ((Fin N → ℝ) × (Fin N → ℝ))
  k₀ : Fin N → ℝ

/-- A capital path is feasible if it starts at k₀ and consecutive pairs lie in A. -/
def ReducedPlanningProblem.IsFeasible {N : ℕ} (P : ReducedPlanningProblem N)
    (k : ℕ → (Fin N → ℝ)) : Prop :=
  k 0 = P.k₀ ∧ ∀ t, (k t, k (t + 1)) ∈ P.A

/-- The discounted objective Σ_t δ^t u(k_{t-1}, k_t) truncated to T periods. -/
noncomputable def ReducedPlanningProblem.objective {N : ℕ} (P : ReducedPlanningProblem N)
    (k : ℕ → (Fin N → ℝ)) (T : ℕ) : ℝ :=
  ∑ t ∈ Finset.range T, P.δ ^ t * P.u (k t) (k (t + 1))