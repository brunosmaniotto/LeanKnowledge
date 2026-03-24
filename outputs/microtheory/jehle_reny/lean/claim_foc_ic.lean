import Mathlib
open BigOperators
set_option linter.unusedVariables false

theorem claim_foc_ic
    {X : Type*} [Fintype X]
    (p_bar : X → ℝ → ℝ)
    (v     : X → ℝ)
    (c_bar : ℝ → ℝ)
    (t : ℝ)
    (hp : ∀ x, HasDerivAt (p_bar x) (deriv (p_bar x) t) t)
    (hc : HasDerivAt c_bar (deriv c_bar t) t)
    (hIC : IsLocalMax (fun r => (∑ x : X, p_bar x r * v x) - c_bar r) t) :
    deriv c_bar t = ∑ x : X, deriv (p_bar x) t * v x := by
  have hsum : HasDerivAt (fun r => ∑ x : X, p_bar x r * v x)
      (∑ x : X, deriv (p_bar x) t * v x) t := by
    have hfun : (fun r => ∑ x : X, p_bar x r * v x) =
                ∑ x ∈ (Finset.univ : Finset X), (fun r => p_bar x r * v x) := by
      ext r; simp [Finset.sum_apply]
    rw [hfun]
    apply HasDerivAt.sum
    intro x _
    exact (hp x).mul_const (v x)
  have hU : HasDerivAt (fun r => (∑ x : X, p_bar x r * v x) - c_bar r)
      ((∑ x : X, deriv (p_bar x) t * v x) - deriv c_bar t) t :=
    hsum.sub hc
  linarith [hIC.hasDerivAt_eq_zero hU]