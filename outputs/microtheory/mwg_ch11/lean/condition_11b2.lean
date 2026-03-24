import Mathlib
open Topology

theorem Condition_11B2
    (φ₁ φ₂ : ℝ → ℝ)
    (h₀ d₁ d₂ : ℝ)
    (hd₁ : HasDerivAt φ₁ d₁ h₀)
    (hd₂ : HasDerivAt φ₂ d₂ h₀)
    (hmax : IsLocalMax (fun h => φ₁ h + φ₂ h) h₀) :
    d₁ = -d₂ := by
  have hsum : HasDerivAt (fun h => φ₁ h + φ₂ h) (d₁ + d₂) h₀ := hd₁.add hd₂
  have h0 : d₁ + d₂ = 0 := hmax.hasDerivAt_eq_zero hsum
  linarith