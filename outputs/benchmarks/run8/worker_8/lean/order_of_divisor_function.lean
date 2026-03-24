import Mathlib

open Asymptotics
open Real

theorem Order_of_Divisor_Function :
    (fun (x : ℝ) => (∑ n ∈ Finset.Icc 1 (Nat.floor x), (n.divisors.card : ℝ)) -
      (x * log x + (2 * eulerMascheroniConstant - 1) * x)) =O[atTop] (fun x : ℝ => Real.sqrt x) := by
  sorry