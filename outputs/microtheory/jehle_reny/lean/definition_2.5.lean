import Mathlib

/-- The certainty equivalent of a gamble with expected utility `eu` under Bernoulli
    utility function `u`: the wealth level CE such that u(CE) = eu. -/
noncomputable def certaintyEquivalent (u : ℝ → ℝ) (eu : ℝ) : ℝ :=
  Classical.epsilon (fun c => u c = eu)

/-- The risk premium for a gamble with expected value `eg` and expected utility `eu`
    under utility function `u`: the amount P such that u(E(g) − P) = u(g),
    equivalently P = E(g) − CE. -/
noncomputable def riskPremium (u : ℝ → ℝ) (eu : ℝ) (eg : ℝ) : ℝ :=
  eg - certaintyEquivalent u eu