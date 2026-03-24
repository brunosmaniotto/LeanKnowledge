import Mathlib
open BigOperators

noncomputable def expenditureMinimization
    {ι : Type*} [Fintype ι]
    (p : ι → ℝ) (u : (ι → ℝ) → ℝ) (ū : ℝ) : ℝ :=
  ⨅ (x : ι → ℝ) (_ : ∀ i, 0 ≤ x i) (_ : ū ≤ u x),
    ∑ i : ι, p i * x i