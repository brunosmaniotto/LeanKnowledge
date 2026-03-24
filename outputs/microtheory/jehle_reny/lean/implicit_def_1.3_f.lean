import Mathlib

open BigOperators
open Topology

/-- The Lagrangian for the consumer's problem: L(x, λ) = u(x) − λ[p · x − y].
    Here x is the consumption bundle, λ is the Lagrange multiplier,
    p is the price vector, and y is wealth. -/
noncomputable def consumer_lagrangian
    {n : ℕ} (u : (Fin n → ℝ) → ℝ) (p : Fin n → ℝ) (y : ℝ)
    (x : Fin n → ℝ) (lam : ℝ) : ℝ :=
  u x - lam * (∑ i, p i * x i - y)