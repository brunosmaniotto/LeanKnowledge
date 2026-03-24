import Mathlib

namespace MWG

/-- The image of a set A under f is {y : y = f(x) for some x ∈ A}. -/
abbrev imageOfSet {X : Type*} {K : ℕ} (f : X → Fin K → ℝ) (A : Set X) : Set (Fin K → ℝ) :=
  f '' A

end MWG