import Mathlib
open Topology

theorem theorem_A1_7
    {m n : ℕ}
    {D : Set (EuclideanSpace ℝ (Fin m))}
    {f : EuclideanSpace ℝ (Fin m) → EuclideanSpace ℝ (Fin n)}
    (hD : IsCompact D)
    (hf : Continuous f) :
    IsCompact (f '' D) :=
  hD.image hf