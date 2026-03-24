import Mathlib

open scoped Real
open Topology

variable {α β : ℝ}

-- Define γ based on the problem's context: γ = α^(α / (1 - α)) * (1 - α)
noncomputable def gamma (α : ℝ) : ℝ := (α^(α / (1 - α))) * (1 - α)

-- Lemma to prove that γ is positive under the given conditions.
lemma gamma_is_positive (hα_pos : 0 < α) (hα_lt_one : α < 1) :
  0 < gamma α := by
  unfold gamma
  -- If α < 1, then 1 - α is positive.
  have h1_minus_alpha_pos : 0 < 1 - α := by linarith [hα_lt_one]
  -- For x^y to be positive, x must be positive.
  have h_alpha_rpow_pos : 0 < α^(α / (1 - α)) := by
    apply Real.rpow_pos_of_pos hα_pos
  -- The product of two positive numbers is positive.
  exact mul_pos h_alpha_rpow_pos h1_minus_alpha_pos

-- Lemma to prove that the exponent β/(1-α) is greater than 1
-- when α + β > 1 and 0 < α < 1 and 0 < β.