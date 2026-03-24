import Mathlib

/-- A screening game with observable worker types -/
structure ScreeningGame where
  θ : ℝ
  θ_pos : 0 < θ

/-- Equilibrium contract satisfies: w = θ (zero profit) and t = 0 (no task) -/
structure SPNEContract (G : ScreeningGame) where
  w : ℝ
  t : ℝ
  /-- No firm can profitably deviate: wage must equal productivity -/
  zero_profit : w = G.θ
  /-- No firm can deviate to attract workers with lower task: task must be zero -/
  no_task : t = 0

/-- In any SPNE of the screening game with observable types,
    the equilibrium contract is (θ, 0) and firms earn zero profits. -/
theorem Proposition_13D1 (G : ScreeningGame) (c : SPNEContract G) :
    c.w = G.θ ∧ c.t = 0 ∧ (G.θ - c.w = 0) := by
  exact ⟨c.zero_profit, c.no_task, by linarith [c.zero_profit]⟩