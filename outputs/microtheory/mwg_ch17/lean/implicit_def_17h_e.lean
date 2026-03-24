import Mathlib

open Matrix
open Topology

/-- Newton's method for price adjustment: dp/dt = -λ [Dẑ(p)]⁻¹ ẑ(p).
    The market agent adjusts prices to cause a proportional decrease in excess demands:
    Dẑ(p(t))·(dp/dt) = -λ ẑ(p(t)). -/
noncomputable def newtonPriceAdjustment
    {L : ℕ}
    (z : EuclideanSpace ℝ (Fin L) → EuclideanSpace ℝ (Fin L))
    (Dz : EuclideanSpace ℝ (Fin L) → Matrix (Fin L) (Fin L) ℝ)
    (lambda : ℝ)
    (p : EuclideanSpace ℝ (Fin L)) :
    EuclideanSpace ℝ (Fin L) :=
  (EuclideanSpace.equiv (Fin L) ℝ).symm (-lambda • (Dz p)⁻¹ *ᵥ (EuclideanSpace.equiv (Fin L) ℝ (z p)))