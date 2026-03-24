import Mathlib

noncomputable def poolingPremium (α πL πH : ℝ) : ℝ := α * πL + (1 - α) * πH

noncomputable def poolingExpectedProfit (α πL πH B p : ℝ) : ℝ := p - poolingPremium α πL πH * B

def poolingAccept (α πL πH B p : ℝ) : Prop := p > poolingPremium α πL πH * B