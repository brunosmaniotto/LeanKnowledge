import Mathlib

namespace MWG

def IsBounded {N : ℕ} (A : Set (EuclideanSpace ℝ (Fin N))) : Prop :=
  ∃ r : ℝ, ∀ x ∈ A, ‖x‖ < r