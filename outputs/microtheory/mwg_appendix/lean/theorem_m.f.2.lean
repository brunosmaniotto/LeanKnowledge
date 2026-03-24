import Mathlib

open Set

-- Part (i): Continuous image of a compact set is compact
theorem Theorem_M_F_2_i
    {N K : ℕ} {X : Set (EuclideanSpace ℝ (Fin N))}
    {f : EuclideanSpace ℝ (Fin N) → EuclideanSpace ℝ (Fin K)}
    (hf : ContinuousOn f X)
    {A : Set (EuclideanSpace ℝ (Fin N))}
    (hA : IsCompact A) (hAX : A ⊆ X) :
    IsCompact (f '' A) :=
  hA.image_of_continuousOn (hf.mono hAX)

-- Part (ii): Continuous real-valued function on compact nonempty set attains its maximum