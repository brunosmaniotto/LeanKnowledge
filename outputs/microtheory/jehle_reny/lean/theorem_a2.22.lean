import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- **Envelope Theorem** (MWG Theorem A2.22). If x(a) uniquely solves a constrained
    optimization with one binding constraint, then ∂V/∂aⱼ = ∂L/∂aⱼ at (x(a), λ(a)). -/
theorem envelope_theorem
    (n : ℕ)
    -- Partial derivatives of f, g w.r.t. xᵢ and ∂xᵢ/∂aⱼ, evaluated at (x(a), a)
    (df_dx dg_dx dx_da : Fin n → ℝ)
    -- ∂f/∂aⱼ, ∂g/∂aⱼ, Lagrange multiplier, and ∂V/∂aⱼ
    (df_da dg_da lam dV_da : ℝ)
    -- KKT first-order conditions: ∂f/∂xᵢ = λ · ∂g/∂xᵢ for all i
    (hKKT : ∀ i : Fin n, df_dx i = lam * dg_dx i)
    -- Chain rule: dV/daⱼ = Σᵢ (∂f/∂xᵢ)(∂xᵢ/∂aⱼ) + ∂f/∂aⱼ
    (hChain : dV_da = ∑ i : Fin n, df_dx i * dx_da i + df_da)
    -- Differentiated binding constraint: Σᵢ (∂g/∂xᵢ)(∂xᵢ/∂aⱼ) + ∂g/∂aⱼ = 0
    (hBind : ∑ i : Fin n, dg_dx i * dx_da i + dg_da = 0) :
    -- Conclusion: ∂V/∂aⱼ = ∂f/∂aⱼ - λ · ∂g/∂aⱼ = ∂L/∂aⱼ
    dV_da = df_da - lam * dg_da := by
  -- From binding constraint: Σᵢ (∂g/∂xᵢ)(∂xᵢ/∂aⱼ) = -∂g/∂aⱼ
  have hSumG : ∑ i : Fin n, dg_dx i * dx_da i = -dg_da := by linarith
  -- KKT substitution: each ∂f/∂xᵢ · ∂xᵢ/∂aⱼ = λ · (∂g/∂xᵢ · ∂xᵢ/∂aⱼ)
  have key : ∀ i : Fin n, df_dx i * dx_da i = lam * (dg_dx i * dx_da i) := by
    intro i; rw [hKKT i]; ring
  -- Rewrite chain rule using KKT, factor out λ, substitute constraint
  simp_rw [key] at hChain
  rw [← Finset.mul_sum, hSumG] at hChain
  -- hChain : dV_da = lam * (-dg_da) + df_da = df_da - lam * dg_da
  rw [hChain]; ring