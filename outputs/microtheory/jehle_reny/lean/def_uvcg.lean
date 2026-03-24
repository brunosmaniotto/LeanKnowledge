import Mathlib

open BigOperators Finset

/-- The VCG expected utility for agent i when reporting truthfully.
    U^VCG_i(t_i) = Σ_{t_{-i}} q_{-i}(t_{-i}) · v_i(x̂(t_i, t_{-i}), t_i) - c̄^VCG_i(t_i) -/
noncomputable def vcgExpectedUtility
    {I : ℕ} {T : Fin I → Type*} {X : Type*}
    [∀ i, Fintype (T i)] [Fintype X] [DecidableEq X]
    (i : Fin I)
    (q_neg_i : (∀ j : {j // j ≠ i}, T j) → ℝ)
    (v : Fin I → X → T i → ℝ)
    (x_hat : T i → (∀ j : {j // j ≠ i}, T j) → X)
    (c_bar_vcg : T i → ℝ)
    (t_i : T i) : ℝ :=
  ∑ t_neg_i : (∀ j : {j // j ≠ i}, T j),
    q_neg_i t_neg_i * v i (x_hat t_i t_neg_i) t_i
  - c_bar_vcg t_i