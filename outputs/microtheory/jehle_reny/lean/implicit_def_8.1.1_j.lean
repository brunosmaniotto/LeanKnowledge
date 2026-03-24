import Mathlib

open Finset

/-- Adverse selection in insurance markets: as the price of insurance rises,
    low-risk consumers exit the market, the remaining buyer pool becomes
    riskier on average (those who stay have the highest accident probabilities),
    and this negative composition effect can outweigh the positive price effect
    on expected profits. -/
structure AdverseSelection (ι : Type*) [Fintype ι] [DecidableEq ι] where
  /-- Accident probability for each consumer -/
  accidentProb : ι → ℝ
  /-- All probabilities lie in [0, 1] -/
  prob_nonneg : ∀ i, 0 ≤ accidentProb i
  prob_le_one : ∀ i, accidentProb i ≤ 1
  /-- The set of consumers who purchase insurance at price p -/
  buyers : ℝ → Finset ι
  /-- Higher price → weakly fewer buyers -/
  buyers_antitone : Antitone buyers
  /-- Those who continue buying at higher prices have weakly higher
      accident probability than those who drop out -/
  selection_effect : ∀ p₁ p₂ : ℝ, p₁ ≤ p₂ →
    ∀ i ∈ buyers p₂, ∀ j ∈ buyers p₁, j ∉ buyers p₂ →
      accidentProb j ≤ accidentProb i
  /-- Expected profit from the insurance pool at price p -/
  expectedProfit : ℝ → ℝ
  /-- The adverse selection effect can dominate: profit is not monotone in price -/
  profit_nonMono : ¬Monotone expectedProfit