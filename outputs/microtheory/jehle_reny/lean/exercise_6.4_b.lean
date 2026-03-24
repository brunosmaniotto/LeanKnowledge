import Mathlib

open Topology Filter

variable {N : ℕ}

/-- Define the binary relation ≿ on ℝ^N by: (a1,...,aN) ≿ (b1,...,bN) if
    there exists a continuous function W: ℝ^N → ℝ such that W(a) ≥ W(b).

    This interpretation assumes that "fu(x) ≥ fu(y) for some continuous utility profile u and some pair x, y with ui(x) = ai, ui(y) = bi for all i"
    implies that `a` and `b` can be considered as the images `u(x)` and `u(y)` respectively, and `fu` is a social welfare function `W ∘ u` for some
    continuous `W : EuclideanSpace ℝ (Fin N) → ℝ`.
    The existence of `X`, `u`, `x`, `y` is always satisfiable for any `a, b ∈ EuclideanSpace ℝ (Fin N)` by choosing `X = Fin 2` (a discrete space)
    and `u(0) = a`, `u(1) = b`.
-/
def preference_relation_on_RN (a b : EuclideanSpace ℝ (Fin N)) : Prop :=
  ∃ (W : C(EuclideanSpace ℝ (Fin N), ℝ)), W a ≥ W b