import Mathlib
open Topology

theorem second_highest_order_statistic_density
    (N : ℕ) (hN : 2 ≤ N) (v : ℝ) :
    HasDerivAt (fun x : ℝ => x ^ N + (↑N : ℝ) * x ^ (N - 1) * (1 - x))
              ((↑N : ℝ) * ((↑N : ℝ) - 1) * v ^ (N - 2) * (1 - v)) v := by
  obtain ⟨n, rfl⟩ : ∃ n, N = n + 2 := ⟨N - 2, by omega⟩
  have h1 : n + 2 - 1 = n + 1 := by omega
  have h2 : n + 2 - 2 = n := by omega
  simp only [h1, h2]
  -- Rewrite CDF to polynomial form: (n+2)·x^(n+1) - (n+1)·x^(n+2)
  have hfun : (fun x : ℝ => x ^ (n + 2) + (↑(n + 2) : ℝ) * x ^ (n + 1) * (1 - x)) =
              (fun x : ℝ => (↑(n + 2) : ℝ) * x ^ (n + 1) - (↑(n + 1) : ℝ) * x ^ (n + 2)) := by
    ext x; push_cast; ring
  rw [hfun]
  exact (((hasDerivAt_pow (n + 1) v).const_mul (↑(n + 2) : ℝ)).sub
    ((hasDerivAt_pow (n + 2) v).const_mul (↑(n + 1) : ℝ))).congr_deriv (by push_cast; ring)