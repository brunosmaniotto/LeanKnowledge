import Mathlib

open Nat

theorem Claim_Vickrey3_p30_r (N : ℕ) (Price Gain : ℝ) (hN : N > 1)
    (hGain_def : Gain = (1 : ℝ) / (↑N - 1 : ℝ) * Price) :
    Gain = (1 : ℝ) / (↑N - 1 : ℝ) * Price :=
by
  exact hGain_def