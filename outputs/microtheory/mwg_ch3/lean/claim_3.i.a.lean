import Mathlib
open Topology

/-
We model the welfare ranking result abstractly:
- e(p, u) is an expenditure function (monotone in u for fixed p)
- EV = e(p⁰, u¹) - e(p⁰, u⁰) and CV = e(p¹, u¹) - e(p¹, u⁰)
- Both are positive iff u¹ > u⁰ (consumer is better off under p¹)
-/

theorem welfare_ranking_EV_CV
    (e : ℝ → ℝ → ℝ)  -- e(p, u): expenditure function
    (p₀ p₁ u₀ u₁ : ℝ)
    -- expenditure is strictly monotone in utility for any fixed price
    (h_mono_p0 : StrictMono (e p₀))
    (h_mono_p1 : StrictMono (e p₁))
    -- identity: e(p, v(p, w)) = w, so e(p⁰, u⁰) = e(p⁰, u⁰) is just the wealth
    -- EV = e(p⁰, u¹) - e(p⁰, u⁰), CV = e(p¹, u¹) - e(p¹, u⁰)
    : (0 < e p₀ u₁ - e p₀ u₀ ↔ u₀ < u₁) ∧
      (0 < e p₁ u₁ - e p₁ u₀ ↔ u₀ < u₁) := by
  constructor
  · constructor
    · intro h
      by_contra h_neg
      push_neg at h_neg
      have := h_mono_p0.monotone h_neg
      linarith
    · intro h
      have := h_mono_p0 h
      linarith
  · constructor
    · intro h
      by_contra h_neg
      push_neg at h_neg
      have := h_mono_p1.monotone h_neg
      linarith
    · intro h
      have := h_mono_p1 h
      linarith