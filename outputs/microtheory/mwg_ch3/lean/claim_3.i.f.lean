import Mathlib

open Finset BigOperators
open BigOperators

/-- First-order approximation welfare test via concavity of the expenditure function.
    If e is concave in p, then e(p¹, u⁰) ≤ e(p⁰, u⁰) + (p¹ − p⁰) · x⁰,
    so (p¹ − p⁰) · x⁰ < 0 implies e(p¹, u⁰) < e(p⁰, u⁰) (welfare improvement). -/
theorem first_order_approximation_welfare_test
    {L : ℕ}
    (e : (Fin L → ℝ) → ℝ)
    (p0 p1 x0 : Fin L → ℝ)
    (h_concavity : e p1 ≤ e p0 + ∑ i : Fin L, (p1 i - p0 i) * x0 i)
    (h_test : ∑ i : Fin L, (p1 i - p0 i) * x0 i < 0) :
    e p1 < e p0 := by
  linarith