import Mathlib

/-- (N+1)-Sector Model production set.
Given N capital goods, a consumption good, and labor:
- `A` is the admissible domain of (capital, labor, next-period capital) combinations
- `G` is the production function
- The production set Y subtracts the non-negative orthant (free disposal). -/
noncomputable def Example_20C4
    (N : ℕ)
    (A : Set ((Fin N → ℝ) × ℝ × (Fin N → ℝ)))
    (G : (Fin N → ℝ) → ℝ → (Fin N → ℝ) → ℝ) :
    Set ((Fin N → ℝ) × ℝ × ℝ × (Fin N → ℝ) × ℝ × ℝ) :=
  {y | ∃ (k : Fin N → ℝ) (l : ℝ) (k' : Fin N → ℝ) (x : ℝ)
       (dk : Fin N → ℝ) (dl : ℝ) (dc : ℝ) (dk' : Fin N → ℝ) (dx : ℝ) (dlab : ℝ),
    (k, l, k') ∈ A ∧
    x ≤ G k l k' ∧
    (∀ i, 0 ≤ dk i) ∧ 0 ≤ dl ∧ 0 ≤ dc ∧
    (∀ i, 0 ≤ dk' i) ∧ 0 ≤ dx ∧ 0 ≤ dlab ∧
    y = (fun i => -k i - dk i,
         -dc,
         -l - dl,
         fun i => k' i - dk' i,
         x - dx,
         -dlab)}