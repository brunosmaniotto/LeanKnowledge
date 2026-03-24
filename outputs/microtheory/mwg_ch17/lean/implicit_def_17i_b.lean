import Mathlib
open Topology
open BigOperators

noncomputable def perReplicaExcessDemand
    {ι : Type*} {L : ℕ}
    (z : ι → (Fin L → ℝ) → Set (Fin L → ℝ))
    (i : ι)
    (r : ℕ)
    (hr : 0 < r)
    (p : Fin L → ℝ) : Set (Fin L → ℝ) :=
  {x : Fin L → ℝ |
    ∃ selections : Fin r → (Fin L → ℝ),
      (∀ n, selections n ∈ z i p) ∧
      x = fun l => (1 / (r : ℝ)) * ∑ n : Fin r, selections n l}