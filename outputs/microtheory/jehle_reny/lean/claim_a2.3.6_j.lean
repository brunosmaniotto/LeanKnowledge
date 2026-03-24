import Mathlib
open Topology

/-- The linear independence constraint qualification is necessary for KKT.
    Counterexample: max f(x)=x s.t. g(x)=x³≤0. At x*=0, ∇g(0)=0 so KKT fails. -/
theorem Claim_A2_3_6_j :
    -- (1) x* = 0 is feasible: g(0) = 0³ ≤ 0
    (0 : ℝ) ^ 3 ≤ 0
    -- (2) x* = 0 is optimal: x³ ≤ 0 → x ≤ 0
    ∧ (∀ x : ℝ, x ^ 3 ≤ 0 → x ≤ 0)
    -- (3) ∇f(0) = 1
    ∧ deriv id (0 : ℝ) = 1
    -- (4) ∇g(0) = 0
    ∧ deriv (fun x : ℝ => x ^ 3) 0 = 0
    -- (5) KKT fails: no λ ≥ 0 satisfies 1 = λ · 0
    ∧ (∀ lam : ℝ, 0 ≤ lam → lam * 0 ≠ 1) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · norm_num
  · intro x hx
    by_contra h
    push_neg at h
    have : 0 < x ^ 3 := by positivity
    linarith
  · simp [deriv_id']
  · simp [deriv_pow]
  · intro lam _
    simp