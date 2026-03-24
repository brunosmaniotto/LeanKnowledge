import Mathlib
open Topology

/--
If preferences admit Gorman-form indirect utility v_i(p, w) = a_i(p) + b(p) * w
with common b(p), then the expenditure function e_i(p, u) = (u - a_i(p)) / b(p)
is affine in u, i.e., e_i(p, u) = c(p) * u + d_i(p) where c(p) = 1/b(p).
-/
theorem gorman_form_expenditure
    (a b : ℝ) (hb : b ≠ 0)
    (v : ℝ → ℝ)  -- indirect utility as function of wealth
    (hv : ∀ w, v w = a + b * w)
    (e : ℝ → ℝ)  -- expenditure as function of utility
    (he : ∀ u, e u = (u - a) / b) :
    ∃ c d : ℝ, ∀ u, e u = c * u + d := by
  refine ⟨1 / b, -(a / b), fun u => ?_⟩
  rw [he]
  field_simp
  ring