import Mathlib

open BigOperators MeasureTheory Finset

/-- A simple lottery over outcomes in ℝ, represented by its CDF. -/
structure Lottery where
  cdf : ℝ → ℝ

/-- The compound lottery formed from lotteries L_1, ..., L_K with weights α_1, ..., α_K.
    Its CDF is defined as the weighted sum of component CDFs. -/
noncomputable def compoundLottery (K : ℕ) (L : Fin K → Lottery) (α : Fin K → ℝ) : Lottery where
  cdf := fun x => ∑ k : Fin K, α k * (L k).cdf x

/-- Distribution functions preserve the linear structure of lotteries:
    The CDF of a compound lottery (L_1, ..., L_K; α_1, ..., α_K) equals
    F(x) = Σ_k α_k F_k(x). -/
theorem compound_lottery_cdf (K : ℕ) (L : Fin K → Lottery) (α : Fin K → ℝ) (x : ℝ) :
    (compoundLottery K L α).cdf x = ∑ k : Fin K, α k * (L k).cdf x := by
  rfl