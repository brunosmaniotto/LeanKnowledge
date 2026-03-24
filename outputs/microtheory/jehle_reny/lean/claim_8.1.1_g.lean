import Mathlib
open Topology

theorem Claim_8_1_1_g
    (L π_bar : ℝ)
    (hL : 0 ≤ L)
    (hπ_bar : 0 ≤ π_bar)
    (g : ℝ → ℝ)
    (E_cond : ℝ → ℝ)  -- E(π | π ≥ h(p))
    (hg_def : ∀ p, g p = E_cond p * L)
    (hE_range : ∀ p, 0 ≤ E_cond p ∧ E_cond p ≤ π_bar) :
    ∀ p, 0 ≤ g p ∧ g p ≤ π_bar * L := by
  intro p
  rw [hg_def]
  constructor
  · exact mul_nonneg (hE_range p).1 hL
  · exact mul_le_mul_of_nonneg_right (hE_range p).2 hL