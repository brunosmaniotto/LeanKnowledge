import Mathlib

open MeasureTheory
open Topology

/-- In an incentive-compatible direct selling mechanism, once the probability
assignment function p̄_i(·) and bidder i's expected cost at value zero c̄_i(0)
are chosen, the entire expected cost function c̄_i(·) is uniquely determined
by the integral formula from Theorem 9.5(ii). -/
theorem Claim_9_3_1_a
    (p_bar : ℝ → ℝ) (c_bar₁ c_bar₂ : ℝ → ℝ)
    (h_eq_zero : c_bar₁ 0 = c_bar₂ 0)
    (h1 : ∀ v, c_bar₁ v = c_bar₁ 0 + p_bar v * v - ∫ x in (0 : ℝ)..v, p_bar x)
    (h2 : ∀ v, c_bar₂ v = c_bar₂ 0 + p_bar v * v - ∫ x in (0 : ℝ)..v, p_bar x) :
    c_bar₁ = c_bar₂ := by
  ext v
  rw [h1 v, h2 v, h_eq_zero]