import Mathlib

/-- The independence axiom implies parallel indifference curves:
    if u(L) > u(L'), then α·u(L) + (1-α)·u(L'') > α·u(L') + (1-α)·u(L'')
    for any α > 0. Non-parallel lines would violate this. -/
theorem independence_axiom_parallel
    (uL uL' uL'' α : ℝ)
    (hα_pos : 0 < α)
    (h_strict : uL' < uL) :
    α * uL' + (1 - α) * uL'' < α * uL + (1 - α) * uL'' := by
  linarith [mul_lt_mul_of_pos_left h_strict hα_pos]