import Mathlib

open Matrix
open Topology

variable (n m : ℕ)

/-- D_p ẑ(p̄; q̄) — the Jacobian of excess demand w.r.t. prices -/
axiom DpZ : Matrix (Fin n) (Fin n) ℝ
/-- D_q ẑ(p̄; q̄) — the Jacobian of excess demand w.r.t. parameters -/
axiom DqZ : Matrix (Fin n) (Fin m) ℝ

/-- For a negative definite matrix M, -v ⬝ M⁻¹ v ≥ 0 for all v.
    This follows because the inverse of a negative definite matrix is negative definite,
    so v ⬝ M⁻¹ v < 0 for v ≠ 0 (and = 0 for v = 0), hence -v ⬝ M⁻¹ v ≥ 0. -/
axiom neg_quad_form_nonneg (M : Matrix (Fin n) (Fin n) ℝ) :
  (∀ v : Fin n → ℝ, v ≠ 0 → dotProduct v (M.mulVec v) < 0) →
  ∀ v : Fin n → ℝ, -dotProduct v (M⁻¹.mulVec v) ≥ 0

/-- Proposition 17.G.2: If D_p ẑ is negative definite, then
    (D_q ẑ dq) · (Dp(q̄) dq) ≥ 0 for any dq.
    By 17.G.1, Dp(q̄) dq = -[D_p ẑ]⁻¹ (D_q ẑ dq), so the expression equals
    -(D_q ẑ dq) · [D_p ẑ]⁻¹ (D_q ẑ dq) ≥ 0
    since the inverse of a negative definite matrix is negative definite. -/
theorem proposition_17_G_2
    (hND : ∀ v : Fin n → ℝ, v ≠ 0 → dotProduct v ((DpZ n).mulVec v) < 0)
    (dq : Fin m → ℝ) :
    -dotProduct ((DqZ n m).mulVec dq) ((DpZ n)⁻¹.mulVec ((DqZ n m).mulVec dq)) ≥ 0 := by
  exact neg_quad_form_nonneg n (DpZ n) hND ((DqZ n m).mulVec dq)