import Mathlib
open Topology
open BigOperators

/-- Claim 3.5(b): Under profit maximization with a strictly increasing production
    function f, the constraint f(x) ≥ y binds at optimum, so the problem reduces
    to max_{x ≥ 0} p·f(x) - w·x.

    We prove: if p > 0 and f(x) > y, then replacing y with f(x) strictly
    improves the objective p·y - w·x. Hence at any optimum y = f(x). -/
theorem Claim_3_5_b
    {n : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (p : ℝ) (hp : p > 0)
    (w : Fin n → ℝ)
    (x : Fin n → ℝ)
    (y : ℝ)
    (hfeas : f x > y) :
    p * y - ∑ i, w i * x i < p * f x - ∑ i, w i * x i := by
  linarith [mul_lt_mul_of_pos_left hfeas hp]