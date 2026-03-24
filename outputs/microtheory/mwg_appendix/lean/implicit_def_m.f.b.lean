import Mathlib

open Set Metric
open Topology

namespace MWG

noncomputable def interiorRelative {n : ℕ} (X A : Set (EuclideanSpace ℝ (Fin n))) : Set (EuclideanSpace ℝ (Fin n)) :=
  {x ∈ A | ∃ ε > 0, ∀ x' ∈ X, dist x' x < ε → x' ∈ A}

noncomputable def closureRelative {n : ℕ} (X A : Set (EuclideanSpace ℝ (Fin n))) : Set (EuclideanSpace ℝ (Fin n)) :=
  X \ interiorRelative X (X \ A)

noncomputable def boundaryRelative {n : ℕ} (X A : Set (EuclideanSpace ℝ (Fin n))) : Set (EuclideanSpace ℝ (Fin n)) :=
  closureRelative X A \ interiorRelative X A

end MWG