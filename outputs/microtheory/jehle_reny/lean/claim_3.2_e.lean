import Mathlib

open MeasureTheory Topology
open Topology

/-- Strictly increasing in each coordinate -/
def CoordStrictMono {n : ℕ} (f : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ (i : Fin n) (x : Fin n → ℝ) (ε : ℝ), ε > 0 →
    f (Function.update x i (x i + ε)) > f x

/-- Claim 3.2(e): If f is C¹ and strictly increasing in each coordinate,
    then ∂f/∂xᵢ > 0 for almost every x. -/
axiom claim_3_2_e
    {n : ℕ} (f : (Fin n → ℝ) → ℝ)
    (hf : ContDiff ℝ 1 f)
    (hmono : CoordStrictMono f)
    (i : Fin n) :
    ∀ᵐ x ∂volume, fderiv ℝ f x (Pi.single i 1) > 0