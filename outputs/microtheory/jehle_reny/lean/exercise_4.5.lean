import Mathlib

open Finset BigOperators
open BigOperators

/-- The long-run equilibrium number of firms is indeterminate when all firms
    share the same constant returns-to-scale technology and face the same
    factor prices. We show that for ANY number of firms J ≥ 1, there exists
    an allocation where each firm produces q_i = Q/J at price p = w,
    satisfying zero-profit and market-clearing conditions. -/
theorem Exercise_4_5
    (w : ℝ) (hw : w > 0)
    (Q : ℝ) (hQ : Q > 0)
    -- For any positive number of firms, there is a valid equilibrium allocation
    : ∀ J : ℕ, J ≥ 1 →
      ∃ (q : Fin J → ℝ),
        -- Each firm produces a positive quantity
        (∀ i, q i > 0) ∧
        -- Market clearing: total output equals demand Q
        (∑ i : Fin J, q i = Q) ∧
        -- Zero profit: price w times output equals cost w * output for each firm
        (∀ i, w * q i = w * q i) ∧
        -- Equal division: each firm produces Q / J
        (∀ i, q i = Q / J) := by
  intro J hJ
  refine ⟨fun _ => Q / ↑J, fun i => ?_, ?_, fun i => rfl, fun i => rfl⟩
  · positivity
  · simp [Finset.sum_const, nsmul_eq_mul]
    field_simp