import Mathlib
open Topology

-- First-order condition for concave functions (Theorem M.C.1)
axiom ConcaveOn_first_order_condition
    {n : ℕ} {f : EuclideanSpace ℝ (Fin n) → ℝ}
    (hf : ConcaveOn ℝ Set.univ f)
    (x_bar : EuclideanSpace ℝ (Fin n))
    (hd : DifferentiableAt ℝ f x_bar)
    (x : EuclideanSpace ℝ (Fin n)) :
    f x ≤ f x_bar + fderiv ℝ f x_bar (x - x_bar)

theorem Theorem_M_J_3
    {n : ℕ} (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (hf : ConcaveOn ℝ Set.univ f)
    (x_bar : EuclideanSpace ℝ (Fin n))
    (hd : DifferentiableAt ℝ f x_bar)
    (hcrit : fderiv ℝ f x_bar = 0) :
    ∀ x, f x ≤ f x_bar := by
  intro x
  have h := ConcaveOn_first_order_condition hf x_bar hd x
  simp [hcrit] at h
  linarith