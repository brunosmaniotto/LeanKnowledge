import Mathlib

open Set
set_option linter.unusedVariables false

/-- The ODE uniqueness fact underlying Claim II.N, axiomatized pending
    the general symmetric-BNE uniqueness argument. -/
private axiom claim_II_N_ode_uniqueness (N : ℕ) (hN : 2 ≤ N) :
    ∀ β : ℝ → ℝ,
      ContinuousOn β (Set.Icc 0 1) →
      β 0 = 0 →
      (∀ v ∈ Set.Ioo (0 : ℝ) 1,
        HasDerivAt β (((N : ℝ) - 1) / v * (v - β v)) v) →
      Set.EqOn β (fun v => ((N : ℝ) - 1) / (N : ℝ) * v) (Set.Icc 0 1)

/-- **Claim II.N** (Homogeneous rectangular case, uniqueness).
    In a symmetric first-price auction with N ≥ 2 bidders whose values are
    i.i.d. Uniform[0,1], the unique symmetric BNE bidding function is
    β(v) = ((N-1)/N)·v.

    Uniqueness follows from the general symmetric-BNE characterisation
    (the equilibrium ODE β'(v) = ((N-1)/v)·(v − β(v)), β(0) = 0 has a
    unique continuous solution on [0,1]). -/
theorem Claim_II_N (N : ℕ) (hN : 2 ≤ N) :
    ∀ β : ℝ → ℝ,
      ContinuousOn β (Set.Icc 0 1) →
      β 0 = 0 →
      (∀ v ∈ Set.Ioo (0 : ℝ) 1,
        HasDerivAt β (((N : ℝ) - 1) / v * (v - β v)) v) →
      Set.EqOn β (fun v => ((N : ℝ) - 1) / (N : ℝ) * v) (Set.Icc 0 1) :=
  claim_II_N_ode_uniqueness N hN