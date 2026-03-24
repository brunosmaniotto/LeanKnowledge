import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {L : ℕ} (hL : 0 < L)

/-- We model the expenditure function and its properties abstractly. -/
theorem Proposition_3_H_1
    (e : (Fin L → ℝ) → ℝ → ℝ)
    (grad_e : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    -- e is strictly increasing in u (unused in this direction but part of hypothesis)
    -- Differentiability: grad_e is the gradient of e w.r.t. p
    -- Concavity in p: e(p', u) ≤ e(p, u) + ∑ i, grad_e(p,u) i * (p' i - p i)
    (h_concave : ∀ u p p', e p' u ≤ e p u + ∑ i : Fin L, grad_e p u i * (p' i - p i))
    -- Euler's theorem (homogeneity of degree 1): e(p, u) = ∑ i, p i * grad_e(p, u) i
    (h_euler : ∀ u p, e p u = ∑ i : Fin L, p i * grad_e p u i)
    -- Gradient is nonneg (from e increasing in p)
    (h_grad_nonneg : ∀ u p i, 0 ≤ grad_e p u i)
    -- V_u definition: x ∈ V_u iff for all q >> 0, ∑ i, q i * x i ≥ e(q, u)
    -- We need: grad_e(p, u) ∈ V_u, i.e., for all q, ∑ i, q i * grad_e(p,u) i ≥ e(q, u)
    -- This follows from concavity + Euler
    (u : ℝ) (p : Fin L → ℝ)
    -- The minimum over V_u equals e(p, u):
    -- We prove: e(p, u) = inf { ∑ i, p i * x i | x ∈ V_u }
    -- Since V_u = { x | ∀ q, ∑ i, q i * x i ≥ e(q, u) }
    -- (≤): by definition of V_u with q = p, any x ∈ V_u satisfies ∑ p i * x i ≥ e(p, u)
    -- (≥): grad_e(p, u) ∈ V_u and ∑ p i * grad_e(p,u) i = e(p, u)
    : (∀ x : Fin L → ℝ, (∀ q : Fin L → ℝ, e q u ≤ ∑ i, q i * x i) →
        e p u ≤ ∑ i, p i * x i) ∧
      (∃ x : Fin L → ℝ, (∀ q : Fin L → ℝ, e q u ≤ ∑ i, q i * x i) ∧
        ∑ i, p i * x i = e p u) := by
  constructor
  · -- (≤) direction: any x ∈ V_u satisfies p·x ≥ e(p, u) by definition
    intro x hx
    exact hx p
  · -- (≥) direction: exhibit grad_e(p, u) as witness in V_u with cost = e(p, u)
    refine ⟨grad_e p u, ?_, ?_⟩
    · -- grad_e(p, u) ∈ V_u: for all q, e(q, u) ≤ ∑ i, q i * grad_e(p, u) i
      intro q
      have hc := h_concave u p q
      have he := h_euler u p
      -- From concavity: e(q, u) ≤ e(p, u) + ∑ i, grad_e(p,u) i * (q i - p i)
      -- = ∑ i, p i * grad_e(p,u) i + ∑ i, grad_e(p,u) i * (q i - p i)   [by Euler]
      -- = ∑ i, (p i * grad_e(p,u) i + grad_e(p,u) i * (q i - p i))
      -- = ∑ i, grad_e(p,u) i * q i = ∑ i, q i * grad_e(p,u) i
      calc e q u ≤ e p u + ∑ i, grad_e p u i * (q i - p i) := hc
        _ = (∑ i, p i * grad_e p u i) + ∑ i, grad_e p u i * (q i - p i) := by rw [he]
        _ = ∑ i, (p i * grad_e p u i + grad_e p u i * (q i - p i)) := by rw [← Finset.sum_add_distrib]
        _ = ∑ i, q i * grad_e p u i := by
            apply Finset.sum_congr rfl; intro i _; ring
    · -- ∑ p i * grad_e(p,u) i = e(p, u) by Euler's theorem
      exact (h_euler u p).symm