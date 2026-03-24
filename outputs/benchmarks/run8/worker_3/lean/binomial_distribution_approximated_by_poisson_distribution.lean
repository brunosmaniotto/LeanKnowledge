import Mathlib
open Filter

theorem binomial_approximated_by_poisson (lam : ℝ) (hlam : 0 ≤ lam) (k : ℕ) :
    Tendsto (fun n : ℕ => (Nat.choose n k : ℝ) * (lam / (n : ℝ)) ^ k * ((1 : ℝ) - lam / (n : ℝ)) ^ (n - k))
      atTop (nhds (Real.exp (-lam) * lam ^ k / (Nat.factorial k : ℝ))) := by
  sorry