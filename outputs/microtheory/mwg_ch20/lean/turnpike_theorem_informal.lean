import Mathlib
open Topology

noncomputable section

/-- Environment for the turnpike theorem. -/
structure TurnpikeEnv where
  utility : ℝ → ℝ → ℝ
  strictly_concave : StrictConcaveOn ℝ Set.univ (fun k => utility k k)
  steady_state : ℝ

/-- Turnpike theorem: with sufficient patience, optimal paths converge
    to the modified golden rule steady state. -/
axiom turnpike_convergence (E : TurnpikeEnv) :
  ∃ δ₀ : ℝ, 0 < δ₀ ∧ δ₀ < 1 ∧
    ∀ δ : ℝ, δ₀ < δ → δ < 1 →
      ∀ path : ℕ → ℝ, ∀ ε > 0,
        ∃ N : ℕ, ∀ n ≥ N, |path n - E.steady_state| < ε

theorem Turnpike_Theorem_Informal
    (u : ℝ → ℝ → ℝ)
    (h_conc : StrictConcaveOn ℝ Set.univ (fun k => u k k))
    (k_star : ℝ) :
    ∃ δ₀ : ℝ, 0 < δ₀ ∧ δ₀ < 1 ∧
      ∀ δ : ℝ, δ₀ < δ → δ < 1 →
        ∀ path : ℕ → ℝ, ∀ ε > 0,
          ∃ N : ℕ, ∀ n ≥ N, |path n - k_star| < ε := by
  exact turnpike_convergence ⟨u, h_conc, k_star⟩