import Mathlib

/-
Axiomatized sub-lemmas
-/
axiom auction_price_integral_split {a : ℝ} (h_a_ge_0 : 0 ≤ a) (h_a_le_1 : a ≤ 1) : (∫ x in (0)..1, min x a) = (∫ x in (0)..a, min x a) + (∫ x in (a)..1, min x a)
axiom integral_of_min_left_part {a : ℝ} (h_a_ge_0 : 0 ≤ a) : (∫ x in (0)..a, min x a) = a^2 / 2
axiom integral_of_min_right_part {a : ℝ} (h_a_le_1 : a ≤ 1) : (∫ x in (a)..1, min x a) = a - a^2
axiom combine_integral_parts {a : ℝ} (h_a_ge_0 : 0 ≤ a) (h_a_le_1 : a ≤ 1) (h_split : (∫ x in (0)..1, min x a) = (∫ x in (0)..a, min x a) + (∫ x in (a)..1, min x a)) (h_left : (∫ x in (0)..a, min x a) = a^2 / 2) (h_right : (∫ x in (a)..1, min x a) = a - a^2) : (∫ x in (0)..1, min x a) = a - a^2 / 2

/-
Main theorem
-/
theorem Claim_II.CC {a : ℝ} (h_a_ge_0 : 0 ≤ a) (h_a_le_1 : a ≤ 1) :
    (∫ x in (0)..1, min x a) = a - a^2 / 2 := by
  -- Split the integral into two parts
  have h_split := auction_price_integral_split h_a_ge_0 h_a_le_1
  -- Evaluate the integral from 0 to a
  have h_left_part := integral_of_min_left_part h_a_ge_0
  -- Evaluate the integral from a to 1
  have h_right_part := integral_of_min_right_part h_a_le_1
  -- Combine the results using the combine_integral_parts axiom
  exact combine_integral_parts h_a_ge_0 h_a_le_1 h_split h_left_part h_right_part