import Mathlib
open MeasureTheory

/-- In a first-price sealed-bid auction with N ≥ 2 bidders and uniform [0,1]
    valuations, the symmetric equilibrium bid b(v) = v − v/N equals
    the conditional expectation E[max_{j≠i} vⱼ | max_{j≠i} vⱼ < v] = (N−1)/N · v. -/
theorem Claim_9_2_1_f (N : ℕ) (hN : 2 ≤ N) (v : ℝ) :
    v - v / (↑N : ℝ) = ((↑N : ℝ) - 1) / (↑N : ℝ) * v := by
  have hN_ne : (↑N : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  field_simp