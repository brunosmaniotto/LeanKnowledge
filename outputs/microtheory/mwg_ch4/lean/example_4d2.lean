import Mathlib

open BigOperators Finset

/-- Gorman form aggregation: with indirect utilities v_i(p, w_i) = a_i(p) + b(p) · w_i,
    the sum of utilities equals (Σ a_i(p)) + b(p) · (Σ w_i).
    This shows aggregate demand depends only on aggregate wealth, not its distribution,
    so any wealth distribution rule is optimal under utilitarian SWF. -/
theorem Example_4D2
    {J : ℕ} (a : Fin J → ℝ) (b : ℝ) (w : Fin J → ℝ) :
    ∑ i : Fin J, (a i + b * w i) = (∑ i : Fin J, a i) + b * (∑ i : Fin J, w i) := by
  simp [Finset.sum_add_distrib, Finset.mul_sum]