import Mathlib
open Set
open MeasureTheory
open Topology
open ArithmeticFunction

-- Assume a sequence of positive real zeros of the Riemann zeta function
variable (Li : ℝ → ℝ) (zeros : ℕ → ℝ) (zeros_pos : ∀ n, 0 < zeros n)

noncomputable def bigPi (x : ℝ) : ℝ :=
  Li x - (∑' n, Li (x ^ (zeros n))) - Real.log 2 + ∫ t in Ioi x, 1 / (t * (t ^ 2 - 1) * Real.log t)

theorem exact_form_of_prime_counting (x : ℝ) (hx : 1 < x) :
    (Nat.primeCounting (Int.floor x).toNat : ℝ) =
      ∑' n : ℕ, ((moebius (n + 1) : ℝ) / (n + 1 : ℝ)) * bigPi Li zeros (x ^ (1 / (n + 1 : ℝ))) := by
  admit