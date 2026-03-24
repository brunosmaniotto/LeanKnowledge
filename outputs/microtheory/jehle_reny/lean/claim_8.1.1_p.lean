import Mathlib
open Topology

theorem Claim_8_1_1_p
    (L : ℝ) (hL : 0 < L)
    (p_star : ℝ) (hp : p_star = L)
    (h : ℝ → ℝ)
    (h_breakeven : p_star / L = 1 → h p_star = 1) :
    -- Only consumers with π = 1 buy (threshold is 1)
    h p_star = 1 ∧
    -- They pay exactly L, so net gain is zero
    L - p_star = 0 := by
  have hp_div : p_star / L = 1 := by rw [hp]; field_simp
  exact ⟨h_breakeven hp_div, by linarith⟩