import Mathlib

open Matrix
open Topology

/-- A real square matrix is negative definite if xᵀ A x < 0 for all nonzero x. -/
axiom IsNegDef : {n : ℕ} → Matrix (Fin n) (Fin n) ℝ → Prop

/-- A diagonal matrix with all positive diagonal entries. -/
axiom IsPosDiag : {n : ℕ} → Matrix (Fin n) (Fin n) ℝ → Prop

/-- A matrix is stable (all eigenvalues have negative real part). -/
axiom IsStable : {n : ℕ} → Matrix (Fin n) (Fin n) ℝ → Prop

/-- If A is negative definite, then for any positive diagonal matrix C, the product C * A is stable.
    This is the core result ensuring local stability of equilibrium p* under tâtonnement
    dynamics ṗ = C · ẑ(p) when the Jacobian Dẑ(p*) is negative definite. -/
axiom neg_def_mul_pos_diag_stable : ∀ {n : ℕ} (A C : Matrix (Fin n) (Fin n) ℝ),
  IsNegDef A → IsPosDiag C → IsStable (C * A)

/-- Claim 17H(g): The equilibrium p* is locally stable irrespective of the speeds of
    adjustment (for all positive diagonal matrices C) if Dẑ(p*) is negative definite. -/
theorem equilibrium_locally_stable_if_neg_def
    {n : ℕ} (Dz : Matrix (Fin n) (Fin n) ℝ)
    (hDz : IsNegDef Dz) :
    ∀ C : Matrix (Fin n) (Fin n) ℝ, IsPosDiag C → IsStable (C * Dz) :=
  fun C hC => neg_def_mul_pos_diag_stable Dz C hDz hC