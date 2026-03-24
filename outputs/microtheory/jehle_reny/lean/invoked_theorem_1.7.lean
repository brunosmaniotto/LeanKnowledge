import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {L : ℕ}

/-- Properties of the expenditure function e(p, u):
    Part 6: e is concave in p (first-order characterization).
    Part 7: Shephard's lemma — ∂e/∂pᵢ = hᵢ(p, u). -/
theorem Invoked_Theorem_1_7
    (e : (Fin L → ℝ) → ℝ → ℝ)
    (h : (Fin L → ℝ) → ℝ → (Fin L → ℝ))  -- Hicksian demand
    -- e(p, u) = p · h(p, u): the minimum is attained at the Hicksian demand
    (h_attains : ∀ u p, e p u = ∑ i : Fin L, p i * h p u i)
    -- h(p, u) is feasible and optimal: for any q, e(q, u) ≤ q · h(p, u)
    (h_feasible : ∀ u p q, e q u ≤ ∑ i : Fin L, q i * h p u i)
    -- Shephard's lemma (envelope theorem): ∂e/∂pᵢ = hᵢ(p, u)
    (h_deriv : ∀ u p (i : Fin L),
      HasDerivAt (fun t => e (Function.update p i t) u) (h p u i) (p i))
    (u : ℝ) :
    -- Part 6: Concavity (first-order condition)
    (∀ p p', e p' u ≤ e p u + ∑ i : Fin L, h p u i * (p' i - p i)) ∧
    -- Part 7: Shephard's lemma
    (∀ p (i : Fin L),
      HasDerivAt (fun t => e (Function.update p i t) u) (h p u i) (p i)) := by
  constructor
  · -- Concavity from EMP optimality:
    -- e(p',u) ≤ p'·h(p,u) = p·h(p,u) + h(p,u)·(p'-p) = e(p,u) + h(p,u)·(p'-p)
    intro p p'
    calc e p' u
        ≤ ∑ i, p' i * h p u i := h_feasible u p p'
      _ = (∑ i, p i * h p u i) + ∑ i, h p u i * (p' i - p i) := by
          rw [← Finset.sum_add_distrib]
          apply Finset.sum_congr rfl; intro i _; ring
      _ = e p u + ∑ i, h p u i * (p' i - p i) := by rw [← h_attains]
  · -- Shephard's lemma: directly from envelope theorem hypothesis
    exact fun p i => h_deriv u p i