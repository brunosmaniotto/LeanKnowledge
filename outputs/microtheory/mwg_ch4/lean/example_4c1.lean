import Mathlib
open Topology

/-- MWG Example 4.C.1: Aggregate demand can violate the Weak Axiom
    even when each individual's demand satisfies it. -/
theorem Example_4C1 :
    ∃ (p₁ p₂ p₁' p₂' : ℚ)        -- prices (two commodities)
      (x₁₁ x₁₂ x₂₁ x₂₂ : ℚ)    -- consumer 1 & 2 demands at p
      (x₁₁' x₁₂' x₂₁' x₂₂' : ℚ), -- consumer 1 & 2 demands at p'
    -- Prices are positive
    0 < p₁ ∧ 0 < p₂ ∧ 0 < p₁' ∧ 0 < p₂' ∧
    -- Quantities are nonneg
    0 ≤ x₁₁ ∧ 0 ≤ x₁₂ ∧ 0 ≤ x₂₁ ∧ 0 ≤ x₂₂ ∧
    0 ≤ x₁₁' ∧ 0 ≤ x₁₂' ∧ 0 ≤ x₂₁' ∧ 0 ≤ x₂₂' ∧
    -- Budget equality at own prices (w/2 = 10 for each consumer)
    p₁ * x₁₁ + p₂ * x₁₂ = 10 ∧
    p₁ * x₂₁ + p₂ * x₂₂ = 10 ∧
    p₁' * x₁₁' + p₂' * x₁₂' = 10 ∧
    p₁' * x₂₁' + p₂' * x₂₂' = 10 ∧
    -- Individual WA for consumer 1:
    (p₁ * x₁₁' + p₂ * x₁₂' ≤ 10 →
      p₁' * x₁₁ + p₂' * x₁₂ > 10) ∧
    -- Individual WA for consumer 2:
    (p₁ * x₂₁' + p₂ * x₂₂' ≤ 10 →
      p₁' * x₂₁ + p₂' * x₂₂ > 10) ∧
    -- Aggregate WA VIOLATED: both aggregate bundles affordable at each other's prices
    (p₁ * ((x₁₁' + x₂₁') / 2) + p₂ * ((x₁₂' + x₂₂') / 2) ≤ 10) ∧
    (p₁' * ((x₁₁ + x₂₁) / 2) + p₂' * ((x₁₂ + x₂₂) / 2) ≤ 10) ∧
    ((x₁₁ + x₂₁) / 2 ≠ (x₁₁' + x₂₁') / 2 ∨
     (x₁₂ + x₂₂) / 2 ≠ (x₁₂' + x₂₂') / 2) := by
  -- Witnesses: p=(2,1), p'=(1,2), w/2=10
  -- Consumer 1: x₁(p)=(3,4), x₁(p')=(2,4)  [budget: 6+4=10, 2+8=10]
  -- Consumer 2: x₂(p)=(4,2), x₂(p')=(4,3)  [budget: 8+2=10, 4+6=10]
  -- Individual WA: Consumer 1: p·x₁(p')=8≤10 but p'·x₁(p)=11>10 ✓
  --                Consumer 2: p·x₂(p')=11>10, vacuously true ✓
  -- Aggregate: agg(p)=(7/2,3), agg(p')=(3,7/2)
  --   p·agg(p')=6+7/2=19/2≤10 ✓, p'·agg(p)=7/2+6=19/2≤10 ✓, 7/2≠3 ✓
  refine ⟨2, 1, 1, 2, 3, 4, 4, 2, 2, 4, 4, 3,
    by norm_num, by norm_num, by norm_num, by norm_num,
    by norm_num, by norm_num, by norm_num, by norm_num,
    by norm_num, by norm_num, by norm_num, by norm_num,
    by norm_num, by norm_num, by norm_num, by norm_num,
    ?_, ?_, by norm_num, by norm_num, ?_⟩
  · intro; norm_num   -- 8 ≤ 10 → 11 > 10
  · intro h; linarith -- 11 ≤ 10 is false
  · left; norm_num    -- 7/2 ≠ 3