import Mathlib
open Classical

noncomputable def firstPricePayoff (value bid maxOther : ℝ) : ℝ :=
  if bid > maxOther then value - bid else 0

noncomputable def secondPricePayoff (value bid maxOther : ℝ) : ℝ :=
  if bid > maxOther then value - maxOther else 0

/-- In first-price auctions, shading the bid increases payoff; in second-price,
    payment is independent of own bid, removing the shading incentive. -/
theorem claim_9_2_3_a (value maxOther : ℝ) (hwin : value > maxOther) :
    (∃ b, maxOther < b ∧ b < value ∧
      firstPricePayoff value b maxOther > firstPricePayoff value value maxOther) ∧
    (∀ b₁ b₂, b₁ > maxOther → b₂ > maxOther →
      secondPricePayoff value b₁ maxOther = secondPricePayoff value b₂ maxOther) := by
  constructor
  · refine ⟨(value + maxOther) / 2, by linarith, by linarith, ?_⟩
    unfold firstPricePayoff
    rw [if_pos (by linarith : (value + maxOther) / 2 > maxOther), if_pos hwin]
    linarith
  · intro b₁ b₂ h₁ h₂
    unfold secondPricePayoff
    rw [if_pos h₁, if_pos h₂]