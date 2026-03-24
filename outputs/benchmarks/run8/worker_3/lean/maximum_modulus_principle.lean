import Mathlib

open Metric

theorem maximum_modulus_principle {D : Set ℂ} (hD : IsOpen D) (hD_conn : IsConnected D) {f : ℂ → ℂ}
    (hf : DifferentiableOn ℂ f D) (hfc : ∃ z ∈ D, ∃ w ∈ D, f z ≠ f w) (z : ℂ) (hz : z ∈ D) (δ : ℝ) (hδ : 0 < δ) :
    ∃ ω, ω ∈ ball z δ ∩ D ∧ ‖f ω‖ > ‖f z‖ := by
  sorry