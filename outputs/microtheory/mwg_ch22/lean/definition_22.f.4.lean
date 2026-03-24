import Mathlib

/-- A cooperative solution f is symmetric if whenever two characteristic forms v and v'
    differ only by a permutation π of agent names (v'(S) = v(π(S)) for all S),
    then the solution also differs only by this permutation: f_i(v') = f_{π(i)}(v). -/
def IsSymmetricCooperativeSolution
    {I : Type*} [Fintype I] [DecidableEq I]
    (f : (Finset I → ℝ) → I → ℝ) : Prop :=
  ∀ (v : Finset I → ℝ) (π : Equiv.Perm I),
    let v' := fun S => v (S.map π.toEmbedding)
    ∀ i : I, f v' i = f v (π i)