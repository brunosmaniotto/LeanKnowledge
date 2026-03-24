import Mathlib

/-- Real income: the maximum number of units of a commodity the consumer could
    acquire if spending entire money income `w` at price `p > 0` per unit. -/
noncomputable def realIncome (w : ℝ) (p : ℝ) (hp : p > 0) : ℝ := w / p