import Mathlib
open Topology
set_option linter.unusedVariables false

theorem Claim_9_6_b (t₁ : ℤ) (ht : t₁ < 4) (p : ℝ) (hp : p ≤ 10/9) :
    (max ((t₁ : ℝ) + 5) (2 * (t₁ : ℝ))) + p < 10 := by
  have h : t₁ ≤ 3 := by omega
  have h' : (t₁ : ℝ) ≤ 3 := mod_cast h
  have h_max : max ((t₁ : ℝ) + 5) (2 * (t₁ : ℝ)) ≤ 8 := by
    apply max_le
    · linarith
    · linarith
  calc
    max ((t₁ : ℝ) + 5) (2 * (t₁ : ℝ)) + p ≤ 8 + p := by linarith
    _ ≤ 8 + 10/9 := by linarith
    _ < 10 := by norm_num