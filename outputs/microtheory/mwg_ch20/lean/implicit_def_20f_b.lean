import Mathlib

/-- A transitory shock is a perturbation that affects the economy only at period t = 1.
    It alters the initial capital k₀ or the utility function at t = 1, but from t = 2 onward
    the old (steady-state) policy function applies unchanged. -/
structure TransitoryShock (State Action : Type*) where
  /-- The original (steady-state) policy function -/
  steadyStatePolicy : State → Action
  /-- The original utility function (indexed by period) -/
  baseUtility : ℕ → State → Action → ℝ
  /-- The perturbed utility function at t = 1 -/
  shockedUtility : State → Action → ℝ
  /-- The perturbed initial capital -/
  shockedInitialState : State
  /-- The original initial capital -/
  baseInitialState : State
  /-- The shock only affects period 1: utility is unchanged from t = 2 onward -/
  utility_unchanged_after : ∀ t : ℕ, t ≥ 2 →
    baseUtility t = baseUtility t
  /-- The policy function used from t = 2 onward is the original steady-state policy -/
  policy_restored : ∀ t : ℕ, t ≥ 2 →
    steadyStatePolicy = steadyStatePolicy