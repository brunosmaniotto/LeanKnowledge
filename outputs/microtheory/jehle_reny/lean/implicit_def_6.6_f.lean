import Mathlib

/-- The Atkinson index of equality: `I(y) = yₑ / μ`, where `yₑ` is the equally
    distributed equivalent income and `μ` is the mean of the income distribution `y`.
    Atkinson (1970), Jehle & Reny Exercise 6.14. -/
noncomputable def AtkinsonEqualityIndex (ye μ : ℝ) : ℝ := ye / μ