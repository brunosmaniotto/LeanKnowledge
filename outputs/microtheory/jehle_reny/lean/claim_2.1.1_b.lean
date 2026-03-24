import Mathlib

open Set

/-- A(u) is a convex set for any utility level u, since it is the intersection
    of convex sets A(p, u) over all strictly positive price vectors p.
    An arbitrary intersection of convex sets is convex. -/
theorem Claim_2_1_1_b
    {L : ℕ} {ι : Type*}
    (A : ι → Set (Fin L → ℝ))
    (hA : ∀ i, Convex ℝ (A i)) :
    Convex ℝ (⋂ i, A i) :=
  convex_iInter hA