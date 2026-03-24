import Mathlib

/-- Strong separability of a social welfare function W:
    the marginal rate of social substitution between any two individuals
    i and j is independent of the welfare levels of all other individuals k ≠ i, j.
    The MRS is (∂W/∂uᵢ) / (∂W/∂uⱼ), and the condition requires it to depend
    only on uᵢ and uⱼ. -/
def StronglySeparable {I : Type*} [DecidableEq I] (W : (I → ℝ) → ℝ) : Prop :=
  ∀ (i j : I), i ≠ j →
    ∀ (u u' : I → ℝ),
      u i = u' i → u j = u' j →
        deriv (fun t => W (Function.update u i t)) (u i) /
          deriv (fun t => W (Function.update u j t)) (u j) =
        deriv (fun t => W (Function.update u' i t)) (u' i) /
          deriv (fun t => W (Function.update u' j t)) (u' j)