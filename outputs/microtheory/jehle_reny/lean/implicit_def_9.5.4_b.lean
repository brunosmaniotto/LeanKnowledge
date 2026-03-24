import Mathlib

open Finset BigOperators
open BigOperators

/-- The externality imposed by individual i when the type vector is t ∈ T:
    Σ_{j≠i} v_j(x̃_i(t_{-i}), t_j) − Σ_{j≠i} v_j(x̂(t), t_j),
    the difference in total utility of others when i is absent vs present. -/
noncomputable def externality
    {I : Type*} [Fintype I] [DecidableEq I]
    {T X : Type*}
    (v : I → X → T → ℝ)
    (x_hat : (I → T) → X)
    (x_tilde : I → (I → T) → X)
    (t : I → T)
    (i : I) : ℝ :=
  ∑ j ∈ univ.filter (· ≠ i), v j (x_tilde i t) (t j) -
  ∑ j ∈ univ.filter (· ≠ i), v j (x_hat t) (t j)