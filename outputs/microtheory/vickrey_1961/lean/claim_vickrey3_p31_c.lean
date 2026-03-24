import Mathlib

open MeasureTheory Set Real

theorem claim_vickrey3_p31_c (N : ℕ) (hN : 0 < N) (g : ℝ) (hg0 : 0 ≤ g) (hg1 : g ≤ 1) :
    ↑N * ∫ V in g..1, (V - g) ^ (N - 1) = (1 - g) ^ N := by
  -- Substitution u = V - g, limits [g,1] → [0, 1-g]
  have hsub : ∫ V in g..1, (V - g) ^ (N - 1) =
      ∫ u in (0 : ℝ)..(1 - g), u ^ (N - 1) := by
    rw [intervalIntegral.integral_comp_sub_right (fun u => u ^ (N - 1)) g]
    simp
  rw [hsub, integral_pow]
  -- Key arithmetic: N - 1 + 1 = N and its cast version
  have h1 : N - 1 + 1 = N := by omega
  have h2 : (↑(N - 1) : ℝ) + 1 = ↑N := by exact_mod_cast h1
  have hNne : (↑N : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  -- Simplify exponents (N-1+1 → N), zero^N → 0, and denominator cast
  simp only [h1, zero_pow (show N ≠ 0 by omega), sub_zero, h2]
  -- Cancel: ↑N * ((1-g)^N / ↑N) = (1-g)^N
  field_simp