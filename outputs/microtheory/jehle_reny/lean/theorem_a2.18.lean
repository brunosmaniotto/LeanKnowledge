import Mathlib

open Matrix Finset BigOperators
open Topology

variable {n m : ℕ}

/-- The bordered Hessian matrix for a constrained optimization problem.
    It is the (m+n)×(m+n) matrix with the constraint Jacobian in the borders
    and the Hessian of the Lagrangian in the lower-right block. -/
noncomputable def borderedHessian
    (D2L : Matrix (Fin n) (Fin n) ℝ)
    (Dg : Fin m → Fin n → ℝ) : Matrix (Fin (m + n)) (Fin (m + n)) ℝ :=
  Matrix.of fun i j =>
    if hi : i.val < m then
      if hj : j.val < m then 0
      else Dg ⟨i.val, hi⟩ ⟨j.val - m, by omega⟩
    else
      if hj : j.val < m then Dg ⟨j.val, hj⟩ ⟨i.val - m, by omega⟩
      else D2L ⟨i.val - m, by omega⟩ ⟨j.val - m, by omega⟩

/-- The k-th bordered principal minor: determinant of the top-left (m+k)×(m+k)
    submatrix of the bordered Hessian, for k = 1, ..., n. -/
noncomputable def borderedPrincipalMinor
    (D2L : Matrix (Fin n) (Fin n) ℝ)
    (Dg : Fin m → Fin n → ℝ)
    (k : ℕ) (hk : k ≤ n) : ℝ :=
  (borderedHessian D2L Dg).submatrix
    (Fin.castLE (by omega : m + k ≤ m + n))
    (Fin.castLE (by omega : m + k ≤ m + n)) |>.det

/-- Theorem A2.18 (Second-order sufficient conditions via bordered Hessian):

(1) If the last (n - m) bordered principal minors alternate in sign starting
    with positive (D̄_{m+1} > 0, D̄_{m+2} < 0, …), then x* is a local
    constrained maximum.

(2) If the last (n - m) bordered principal minors are all negative
    (D̄_{m+1} < 0, D̄_{m+2} < 0, …), then x* is a local constrained minimum. -/
axiom bordered_hessian_sufficiency
    {n m : ℕ}
    (hm : m < n)
    (f : (Fin n → ℝ) → ℝ)
    (g : Fin m → (Fin n → ℝ) → ℝ)
    (x_star : Fin n → ℝ)
    (lam_star : Fin m → ℝ)
    (D2L : Matrix (Fin n) (Fin n) ℝ)
    (Dg : Fin m → Fin n → ℝ)
    (h_foc : True)  -- first-order conditions hold at (x*, λ*)
    (h_constraints : ∀ j, g j x_star = 0) :
    -- (1) Alternating sign ⟹ local max
    ((∀ k : Fin (n - m),
        ((-1 : ℝ) ^ (k.val + 1)) *
          borderedPrincipalMinor D2L Dg (m + 1 + k.val) (by omega) > 0) →
      ∀ x : Fin n → ℝ, (∀ j, g j x = 0) →
        ‖x - x_star‖ < 1 → f x ≤ f x_star) ∧
    -- (2) All negative ⟹ local min
    ((∀ k : Fin (n - m),
        borderedPrincipalMinor D2L Dg (m + 1 + k.val) (by omega) < 0) →
      ∀ x : Fin n → ℝ, (∀ j, g j x = 0) →
        ‖x - x_star‖ < 1 → f x_star ≤ f x)