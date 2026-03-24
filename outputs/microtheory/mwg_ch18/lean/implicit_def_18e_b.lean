import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The maximal social utility for an economy with H consumers and L commodities.
    Given weights I_h (one per consumer), utility functions u_h, endowments ω_h,
    maximizes ∑ I_h * u_h(x_h) subject to feasibility and non-negativity. -/
noncomputable def maximalSocialUtility
    (H : ℕ) (L : ℕ)
    (I : Fin H → ℝ)
    (u : Fin H → (Fin L → ℝ) → ℝ)
    (ω : Fin H → Fin L → ℝ) : ℝ :=
  sSup { v : ℝ | ∃ x : Fin H → Fin L → ℝ,
    v = ∑ h : Fin H, I h * u h (x h) ∧
    (∀ ℓ : Fin L, ∑ h : Fin H, I h * x h ℓ ≤ ∑ h : Fin H, I h * ω h ℓ) ∧
    (∀ h : Fin H, ∀ ℓ : Fin L, ℓ.val < L - 1 → x h ℓ ≥ 0) }