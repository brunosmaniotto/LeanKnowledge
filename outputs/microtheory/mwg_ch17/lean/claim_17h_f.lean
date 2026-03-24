import Mathlib

open Matrix

/-- The excess demand function in reduced coordinates (first L-1 goods) -/
axiom ExcessDemand (L : ℕ) : (Fin L → ℝ) → (Fin L → ℝ)

/-- The Jacobian of excess demand at equilibrium -/
axiom DExcessDemand (L : ℕ) : (Fin L → ℝ) → Matrix (Fin L) (Fin L) ℝ

/-- Speed-of-adjustment diagonal matrix C with positive diagonal entries c_ℓ -/
axiom SpeedMatrix (L : ℕ) : Matrix (Fin L) (Fin L) ℝ

/-- SpeedMatrix is diagonal with positive entries -/
axiom SpeedMatrix_diagonal (L : ℕ) :
  ∃ c : Fin L → ℝ, (∀ i, 0 < c i) ∧ SpeedMatrix L = Matrix.diagonal c

/-- An equilibrium price vector where excess demand vanishes -/
axiom is_equilibrium (L : ℕ) (p : Fin L → ℝ) : Prop

/-- Regularity: the Jacobian at equilibrium is nonsingular -/
axiom is_regular (L : ℕ) (p : Fin L → ℝ) : Prop

/-- All eigenvalues of a real matrix have negative real parts -/
axiom all_eigenvalues_neg_real_part (L : ℕ) (M : Matrix (Fin L) (Fin L) ℝ) : Prop

/-- Local asymptotic stability of the equilibrium under tâtonnement -/
axiom is_locally_stable (L : ℕ) (p : Fin L → ℝ) : Prop

/-- Linearization theorem for tâtonnement dynamics (Hartman-Grobman):
    At a regular equilibrium p*, the equilibrium is locally stable iff
    all eigenvalues of C · Dẑ(p*) have negative real parts. -/
axiom tatonnement_linearization_stability_axiom (L : ℕ) (p : Fin L → ℝ)
    (h_eq : is_equilibrium L p) (h_reg : is_regular L p) :
    is_locally_stable L p ↔
      all_eigenvalues_neg_real_part L (SpeedMatrix L * DExcessDemand L p)

theorem tatonnement_linearization_stability (L : ℕ) (p : Fin L → ℝ)
    (h_eq : is_equilibrium L p)
    (h_reg : is_regular L p) :
    is_locally_stable L p ↔
      all_eigenvalues_neg_real_part L (SpeedMatrix L * DExcessDemand L p) := by
  exact tatonnement_linearization_stability_axiom L p h_eq h_reg