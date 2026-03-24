import Mathlib

/-- A cooperative solution `f` satisfies the dummy axiom if for every game `v` and every
agent `i` who is a dummy player (adding `i` to any coalition doesn't change the value),
then `fᵢ(v) = v({i})`. -/
def SatisfiesDummyAxiom
    {I : Type*} [Fintype I] [DecidableEq I]
    (f : ((Finset I) → ℝ) → I → ℝ) : Prop :=
  ∀ (v : Finset I → ℝ), v ∅ = 0 →
    ∀ (i : I),
      (∀ (S : Finset I), i ∉ S → v (S ∪ {i}) = v S) →
      f v i = v {i}