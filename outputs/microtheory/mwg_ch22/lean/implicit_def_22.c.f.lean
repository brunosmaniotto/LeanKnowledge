import Mathlib

/-- A social welfare function W : ℝᴵ → ℝ is concave if for all utility vectors u, u'
and all t ∈ [0,1], W(t·u + (1-t)·u') ≥ t·W(u) + (1-t)·W(u').
Concavity of W(·) is interpreted as aversion to inequality. -/
def IsConcaveSWF {I : Type*} (W : (I → ℝ) → ℝ) : Prop :=
  ∀ (u u' : I → ℝ) (t : ℝ), t ∈ Set.Icc (0 : ℝ) 1 →
    W (t • u + (1 - t) • u') ≥ t * W u + (1 - t) * W u'