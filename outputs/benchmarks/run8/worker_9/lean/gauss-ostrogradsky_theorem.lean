import Mathlib
open Finset BigOperators

-- This is true if `Icc a b` has a non-empty interior. `fderivWithin_of_mem_nhds`.
  -- The box `Icc a b` has non-empty interior if `a < b`.
  -- The theorem should probably assume `a < b`. The informal proof does, with `a₁ < a₂`, etc.
  -- If `a=b`, the box is a point, the integral is 0, and the theorem is trivial.
  -- Let's assume `a < b` for simplicity.
  -- `(Icc_mem_nhds_iff _ _).mpr hab` where `hab : a < b`.
  -- Then `fderivWithin_eq_fderiv`.
  -- What if some components of `a` and `b` are equal? Then the box is lower-dimensional.
  -- The theorem `integral_divergence_of_hasFDerivWithinAt_off_countable` doesn't require `a < b`.
  -- `fderivWithin` is used.
  -- So we need `f' i x = fderivWithin ℝ (f i) (Icc a b) x`.
  -- But my `f'` is defined with `fderiv`.
  -- Let's redefine `f'`: `let f' : Fin 3 → ℝ