import Mathlib
open Topology

theorem claim_17I_d_approx (α : ℝ) (hα0 : 0 ≤ α) (hα1 : α ≤ 1) :
    ∀ ε > 0, ∃ N : ℕ, ∀ r : ℕ, N ≤ r →
      ∃ a : ℕ, a ≤ r ∧ |↑a / ↑r - α| < ε := by
  intro ε hε
  obtain ⟨N, hN⟩ := exists_nat_gt (1 / ε)
  refine ⟨N.max 1, fun r hr => ?_⟩
  have hr1 : 1 ≤ r := le_trans (Nat.le_max_right N 1) hr
  have hr_pos : (0 : ℝ) < ↑r := Nat.cast_pos.mpr (by omega)
  have hr_ne : (↑r : ℝ) ≠ 0 := ne_of_gt hr_pos
  have hNr : (N : ℝ) ≤ ↑r := by exact_mod_cast le_trans (Nat.le_max_left N 1) hr
  have hεr : 1 < ε * ↑r := by
    have h : 1 / ε < ↑r := lt_of_lt_of_le hN hNr
    rw [div_lt_iff₀ hε] at h
    linarith [mul_comm ε (↑r : ℝ)]
  refine ⟨⌊α * ↑r⌋₊, ?_, ?_⟩
  · exact Nat.floor_le_of_le (by nlinarith)
  · have h1 : (↑⌊α * ↑r⌋₊ : ℝ) ≤ α * ↑r := Nat.floor_le (by positivity)
    have h2 : α * ↑r < ↑⌊α * ↑r⌋₊ + 1 := Nat.lt_floor_add_one (α * ↑r)
    rw [abs_sub_lt_iff]
    constructor
    · -- ↑⌊α * ↑r⌋₊ / ↑r - α < ε
      -- h1 gives ⌊α*r⌋₊ ≤ α*r, so ⌊α*r⌋₊/r ≤ α, so LHS ≤ 0 < ε
      have : ↑⌊α * ↑r⌋₊ / ↑r ≤ α := by
        rw [div_le_iff₀ hr_pos]
        exact h1
      linarith
    · -- α - ↑⌊α * ↑r⌋₊ / ↑r < ε
      -- h2 gives α*r < ⌊α*r⌋₊ + 1, so α < (⌊α*r⌋₊ + 1)/r
      -- thus α - ⌊α*r⌋₊/r < 1/r < ε
      suffices h : α - ↑⌊α * ↑r⌋₊ / ↑r < 1 / ↑r by
        have : 1 / ↑r < ε := by
          rw [div_lt_iff₀ hr_pos]
          linarith
        linarith
      rw [sub_lt_iff_lt_add, div_add_div_same]
      rw [lt_div_iff₀ hr_pos]
      linarith