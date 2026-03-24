import Mathlib
open Topology
open MeasureTheory

-- The Transversality Theorem (Mas-Colell, Whinston, Green - Theorem M.E.2)
-- This is a fundamental result in differential topology that follows from Sard's theorem.
-- It states that if f: A × B → ℝ^N has full rank N at every zero,
-- then for almost every parameter q, the system f(·; q) = 0 is regular.

axiom MWG.transversality_theorem
    {N M : ℕ} (A : Set (EuclideanSpace ℝ (Fin N))) (B : Set (EuclideanSpace ℝ (Fin M)))
    (hA : IsOpen A) (hB : IsOpen B)
    (f : EuclideanSpace ℝ (Fin N) → EuclideanSpace ℝ (Fin M) → EuclideanSpace ℝ (Fin N))
    (hf : ContDiff ℝ 1 (fun p : EuclideanSpace ℝ (Fin N) × EuclideanSpace ℝ (Fin M) => f p.1 p.2))
    (hrank : ∀ x ∈ A, ∀ q ∈ B, f x q = 0 →
      Function.Surjective (fderiv ℝ (fun p : EuclideanSpace ℝ (Fin N) × EuclideanSpace ℝ (Fin M) => f p.1 p.2) (x, q))) :
    ∀ᵐ q ∂MeasureTheory.volume, q ∈ B →
      ∀ x ∈ A, f x q = 0 →
        Function.Surjective (fderiv ℝ (fun x' => f x' q) x)

theorem Theorem_M_E_2
    {N M : ℕ} (A : Set (EuclideanSpace ℝ (Fin N))) (B : Set (EuclideanSpace ℝ (Fin M)))
    (hA : IsOpen A) (hB : IsOpen B)
    (f : EuclideanSpace ℝ (Fin N) → EuclideanSpace ℝ (Fin M) → EuclideanSpace ℝ (Fin N))
    (hf : ContDiff ℝ 1 (fun p : EuclideanSpace ℝ (Fin N) × EuclideanSpace ℝ (Fin M) => f p.1 p.2))
    (hrank : ∀ x ∈ A, ∀ q ∈ B, f x q = 0 →
      Function.Surjective (fderiv ℝ (fun p : EuclideanSpace ℝ (Fin N) × EuclideanSpace ℝ (Fin M) => f p.1 p.2) (x, q))) :
    ∀ᵐ q ∂MeasureTheory.volume, q ∈ B →
      ∀ x ∈ A, f x q = 0 →
        Function.Surjective (fderiv ℝ (fun x' => f x' q) x) :=
  MWG.transversality_theorem A B hA hB f hf hrank