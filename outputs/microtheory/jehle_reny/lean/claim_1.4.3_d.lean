import Mathlib
open Topology

theorem Claim_1_4_3_d
    (e : ℝ → ℝ → ℝ)
    (v : ℝ → ℝ → ℝ)
    (e_inv : ℝ → ℝ → ℝ)
    (p y : ℝ)
    (h_duality : e p (v p y) = y)
    (h_inv : ∀ p u, e_inv p (e p u) = u) :
    v p y = e_inv p y := by
  have h := h_inv p (v p y)
  rw [h_duality] at h
  exact h.symm