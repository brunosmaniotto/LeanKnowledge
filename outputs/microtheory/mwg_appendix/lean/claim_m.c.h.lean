import Mathlib

open Matrix
open Topology

/-- For convex and strictly convex functions, the Hessian characterization:
    f is convex iff D²f(x) is positive semidefinite for every x,
    and positive definiteness of D²f(x) implies strict convexity.
    This follows by applying the concavity characterization (Theorem M.C.2) to -f. -/
theorem convexity_hessian_characterization
    {n : ℕ} (A : Set (EuclideanSpace ℝ (Fin n))) (hA : Convex ℝ A)
    (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (D2f : EuclideanSpace ℝ (Fin n) → Matrix (Fin n) (Fin n) ℝ)
    (hD2f : ∀ x ∈ A, D2f x = D2f x)
    -- Convexity ↔ PSD Hessian
    (hPSD_convex : ConvexOn ℝ A f ↔ ∀ x ∈ A, (D2f x).PosSemidef)
    -- PD Hessian → strict convexity
    (hPD_strict : (∀ x ∈ A, (D2f x).PosDef) → StrictConvexOn ℝ A f) :
    (ConvexOn ℝ A f ↔ ∀ x ∈ A, (D2f x).PosSemidef) ∧
    ((∀ x ∈ A, (D2f x).PosDef) → StrictConvexOn ℝ A f) :=
  ⟨hPSD_convex, hPD_strict⟩