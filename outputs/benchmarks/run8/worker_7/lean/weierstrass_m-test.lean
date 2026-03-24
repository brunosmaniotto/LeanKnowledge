import Mathlib

open Filter Finset
open scoped Topology

theorem weierstrass_M_test (D : Set ℝ) (f : ℕ → ℝ → ℝ) (M : ℕ → ℝ)
    (h_bound : ∀ n, ∀ x ∈ D, |f n x| ≤ M n) (h_sum : Summable M) :
    TendstoUniformlyOn (fun n x => ∑ i ∈ range n, f i x) (fun x => ∑' i, f i x) atTop D := by
  have h_bound' : ∀ n x, x ∈ D → ‖f n x‖ ≤ M n := by
    intro n x hx
    rw [Real.norm_eq_abs]
    exact h_bound n x hx
  exact tendstoUniformlyOn_tsum_nat h_sum h_bound'