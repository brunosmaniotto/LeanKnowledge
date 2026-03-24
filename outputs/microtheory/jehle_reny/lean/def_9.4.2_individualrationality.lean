import Mathlib

open MeasureTheory Set
open Topology

/-- A direct selling mechanism with `n` bidders, described by
    interim allocation probability `p̄_i` and interim expected payment `c̄_i`. -/
structure DirectMechanism (n : ℕ) where
  p_bar : Fin n → ℝ → ℝ   -- interim allocation probability for bidder i
  c_bar : Fin n → ℝ → ℝ   -- interim expected payment for bidder i

/-- Individual rationality: every bidder obtains non-negative expected payoff
    u_i(v_i) = p̄_i(v_i) · v_i − c̄_i(v_i) ≥ 0 for all v_i ∈ [0,1]. -/
def DirectMechanism.IsIndividuallyRational {n : ℕ} (M : DirectMechanism n) : Prop :=
  ∀ (i : Fin n) (v_i : ℝ), v_i ∈ Set.Icc 0 1 →
    M.p_bar i v_i * v_i - M.c_bar i v_i ≥ 0