import Mathlib

/-
  Principle of optimality for dynamic programming:
  If a path is optimal from k₀, then its tail from any T is optimal from k_T.
  This justifies the recursive policy function ψ.
-/

noncomputable section

-- A dynamic programming problem with state space α
structure DPProblem (α : Type*) where
  feasible : (ℕ → α) → Prop
  objective : (ℕ → α) → ℝ
  tail_feasible : ∀ (path : ℕ → α) (T : ℕ),
    feasible path → feasible (fun t => path (T + t))
  tail_objective : ∀ (path : ℕ → α) (T : ℕ),
    feasible path →
    ∃ c : ℝ, ∀ (path' : ℕ → α),
      feasible path' → path' 0 = path T →
      objective path = c + objective path'  →
      objective (fun t => path (T + t)) ≥ objective path'

-- An optimal path maximizes the objective among feasible paths starting at the same point
def IsOptimal {α : Type*} (P : DPProblem α) (path : ℕ → α) : Prop :=
  P.feasible path ∧
  ∀ (path' : ℕ → α), P.feasible path' → path' 0 = path 0 →
    P.objective path ≥ P.objective path'

-- The tail of a path shifted by T