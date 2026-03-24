import Mathlib
open Topology

theorem expenditure_from_inverse
    {P : Type*}
    (v : P → ℝ → ℝ)
    (e : P → ℝ → ℝ)
    (v_inv : P → ℝ → ℝ)
    (p : P) (u : ℝ)
    (h_inv : ∀ y, v_inv p (v p y) = y)
    (h_ve : v p (e p u) = u) :
    e p u = v_inv p u := by
  have h := h_inv (e p u)
  rw [h_ve] at h
  exact h.symm