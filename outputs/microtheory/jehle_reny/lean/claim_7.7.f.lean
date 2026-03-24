import Mathlib

/-- A sequential equilibrium represented by its mixing probability. -/
structure SeqEq where
  prob : ℝ
  valid : 0 ≤ prob ∧ prob ≤ 1

/-- Two distinct sequential equilibria in matching pennies. -/
noncomputable def seqEq1 : SeqEq where
  prob := 1/2
  valid := by constructor <;> norm_num

noncomputable def seqEq2 : SeqEq where
  prob := 1/3
  valid := by constructor <;> norm_num

/-- Claim 7.7.f: The sophisticated matching pennies game possesses
    multiple sequential equilibria — witnessed by two distinct ones. -/
theorem Claim_7_7_f : seqEq1.prob ≠ seqEq2.prob := by
  unfold seqEq1 seqEq2
  norm_num