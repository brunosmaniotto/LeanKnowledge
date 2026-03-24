import Mathlib
open Topology

/-- Misallocation under asymmetric auctions: if bidder 1's virtual valuation
    φ₁ is continuous and strictly exceeds bidder 2's virtual valuation c = φ₂(v)
    at value v, then there exists v' < v where φ₁(v') still exceeds c,
    so bidder 1 wins the object even when his value is strictly below bidder 2's. -/
theorem Claim_9_4_5_b
    (φ₁ : ℝ → ℝ) (hφ₁_cont : Continuous φ₁)
    (v c : ℝ) (h_strict : c < φ₁ v) :
    ∃ v' : ℝ, v' < v ∧ c < φ₁ v' := by
  have hS : IsOpen {x | c < φ₁ x} := isOpen_lt continuous_const hφ₁_cont
  rw [Metric.isOpen_iff] at hS
  obtain ⟨ε, hε, hball⟩ := hS v h_strict
  refine ⟨v - ε / 2, by linarith, hball ?_⟩
  rw [Metric.mem_ball, Real.dist_eq]
  have : v - ε / 2 - v = -(ε / 2) := by ring
  rw [this, abs_neg, abs_of_pos (by linarith)]
  linarith