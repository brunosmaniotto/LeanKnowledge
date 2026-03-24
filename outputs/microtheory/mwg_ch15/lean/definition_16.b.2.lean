import Mathlib

/-- A feasible allocation `(x, y)` is Pareto optimal if there is no other feasible
    allocation `(x', y')` such that every consumer weakly prefers `x'` and some
    consumer strictly prefers `x'`. (MWG Definition 16.B.2) -/
def IsParetoOptimal
    {I : Type*} [Fintype I]
    {L : Type*}
    (X : I → Set (L → ℝ))          -- consumption sets
    (pref : I → (L → ℝ) → (L → ℝ) → Prop)  -- preference: pref i a b means a ≿_i b
    (strictPref : I → (L → ℝ) → (L → ℝ) → Prop)  -- strict preference: ≻_i
    (A : Set ((I → L → ℝ) × (L → ℝ)))  -- set of feasible allocations (x, y)
    (xy : (I → L → ℝ) × (L → ℝ)) : Prop :=
  xy ∈ A ∧
  ¬∃ xy' ∈ A,
    (∀ i, pref i (xy'.1 i) (xy.1 i)) ∧
    (∃ i, strictPref i (xy'.1 i) (xy.1 i))