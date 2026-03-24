import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- If u is quasiconcave, the first-order conditions for max u(x) s.t. p · x = w are
    sufficient for a global maximum. Quasiconcavity is encoded via its gradient
    characterization (MWG Theorem M.C.3): ∇u(x)·(y − x) ≤ 0 ⟹ u(y) ≤ u(x). -/
theorem foc_sufficient_under_quasiconcavity
    {n : ℕ} (u : (Fin n → ℝ) → ℝ)
    (p : Fin n → ℝ) (w : ℝ)
    (x_star : Fin n → ℝ)
    (hfeas : ∑ i : Fin n, p i * x_star i = w)
    (Du : (Fin n → ℝ) → (Fin n → ℝ))
    (hqc_grad : ∀ (x y : Fin n → ℝ),
      ∑ i : Fin n, Du x i * (y i - x i) ≤ 0 → u y ≤ u x)
    (lam : ℝ)
    (hfoc : ∀ i : Fin n, Du x_star i = lam * p i) :
    ∀ x : Fin n → ℝ, ∑ i : Fin n, p i * x i = w → u x ≤ u x_star := by
  intro x hx
  apply hqc_grad
  suffices h : ∑ i : Fin n, Du x_star i * (x i - x_star i) = 0 by linarith
  have step : ∀ i : Fin n,
      Du x_star i * (x i - x_star i) = lam * (p i * x i - p i * x_star i) :=
    fun i => by rw [hfoc]; ring
  simp_rw [step, ← Finset.mul_sum, Finset.sum_sub_distrib, hx, hfeas, sub_self, mul_zero]