import Mathlib

namespace MWG

/-- A real-valued function on a set D: a function mapping elements of D into ℝ.
    Definition A1.16: f : D → R is real-valued when D is any set and R ⊂ ℝ. -/
abbrev RealValuedFunction {α : Type*} (D : Set α) := ↥D → ℝ

end MWG