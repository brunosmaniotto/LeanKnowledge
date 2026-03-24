import Mathlib

noncomputable def certainty_equivalent (u : ℝ → ℝ) (expected_utility : ℝ) : ℝ :=
  Classical.epsilon (fun c => u c = expected_utility)

noncomputable def probability_premium (u : ℝ → ℝ) (x ε : ℝ) : ℝ :=
  Classical.epsilon (fun π => u x = (1/2 + π) * u (x + ε) + (1/2 - π) * u (x - ε))