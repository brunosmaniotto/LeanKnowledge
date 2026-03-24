import Mathlib

open scoped EuclideanSpace

/-- A sequence `x` in ℝ^N converges to `a` if for every ε > 0 there exists
    an integer M such that ‖x m - a‖ < ε for all m > M. (MWG Definition M.F.1) -/
def MWG.SeqConvergesTo {N : ℕ} (x : ℕ → EuclideanSpace ℝ (Fin N))
    (a : EuclideanSpace ℝ (Fin N)) : Prop :=
  ∀ ε > 0, ∃ M : ℕ, ∀ m : ℕ, m > M → ‖x m - a‖ < ε