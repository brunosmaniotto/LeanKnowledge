import Mathlib

/-- In a discrete (indivisible) goods market, when a buyer's valuation vb exceeds the
    seller's valuation vs, the entire open interval (vs, vb) constitutes a "price range"
    that induces the same optimal allocation (trade of the good), while each price yields
    a different distribution of the gains from trade between buyer and seller. -/
theorem discrete_goods_price_range
    (vs vb : ℝ) (h : vs < vb) :
    ∃ p q : ℝ,
      (vs < p ∧ p < vb) ∧  -- p is in the feasible trading range
      (vs < q ∧ q < vb) ∧  -- q is in the feasible trading range
      p ≠ q ∧               -- they are distinct prices
      -- same allocation: trade is optimal at both (buyer surplus > 0, seller surplus > 0)
      (vb - p > 0 ∧ p - vs > 0) ∧
      (vb - q > 0 ∧ q - vs > 0) ∧
      -- different income distributions: buyer surpluses differ
      (vb - p) ≠ (vb - q) := by
  refine ⟨(2 * vs + vb) / 3, (vs + 2 * vb) / 3, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · constructor <;> linarith
  · constructor <;> linarith
  · intro heq; linarith
  · constructor <;> linarith
  · constructor <;> linarith
  · intro heq; linarith