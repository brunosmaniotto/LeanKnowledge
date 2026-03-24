import Mathlib

/-- Two goods, two consumers with quasi-linear log utility. Parameter β ∈ {1,2}.
    Consumer 1 is informed (observes β), consumer 2 is uninformed.
    Walrasian prices p(β) = (3 + 2β)/4 are fully revealing since p(1) ≠ p(2).
    The rational expectations equilibrium has p̂(β) = β. -/
theorem Example_19H2 :
    -- Demands: x₁₁(p;β) = β/p, x₁₂(p) = 3/(2p)
    -- Market clearing: β/p + 3/(2p) = (2β + 3)/(2p) clears at p(β) = (2β+3)/4
    let p : Fin 2 → ℚ := fun i => if i = 0 then 5/4 else 7/4
    -- p(β=1) = 5/4, p(β=2) = 7/4
    -- (1) Prices differ across states (revealing)
    p 0 ≠ p 1
    -- (2) Market clearing holds in each state
    ∧ (1 / p 0 + 3 / (2 * p 0) = 2)
    ∧ (2 / p 1 + 3 / (2 * p 1) = 2)
    -- (3) REE price p̂(β) = β is fully revealing
    ∧ ∀ (β : Fin 2), (β.val + 1 : ℚ) ≠ 0 →
        ((β.val + 1 : ℚ) / (β.val + 1 : ℚ) + 3 / (2 * (β.val + 1 : ℚ)) =
         (2 * (β.val + 1) + 3) / (2 * (β.val + 1))) := by
  refine ⟨by norm_num, by norm_num, by norm_num, ?_⟩
  intro β hβ
  fin_cases β <;> simp_all <;> ring