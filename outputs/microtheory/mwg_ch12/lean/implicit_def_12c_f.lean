import Mathlib

/-- The Linear City Model of Product Differentiation (Example 12.C.2).
A city on [0,1] with uniformly distributed consumers, two firms at endpoints,
and linear travel costs that introduce product differentiation. -/
structure LinearCityModel where
  /-- Number of consumers, uniformly distributed on [0,1] -/
  M : ℕ
  /-- Unit production cost (positive) -/
  c : ℝ
  /-- Gross benefit each consumer derives from a widget -/
  v : ℝ
  /-- Half the travel cost per unit distance (t/2 > 0, so t > 0) -/
  t_half : ℝ
  /-- Prices set by firm 1 (at location 0) and firm 2 (at location 1) -/
  p₁ : ℝ
  p₂ : ℝ
  hc : 0 < c
  ht : 0 < t_half
  hM : 0 < M

namespace LinearCityModel

/-- The travel cost parameter t = 2 * t_half -/
noncomputable def t (model : LinearCityModel) : ℝ := 2 * model.t_half

/-- Total cost to a consumer at location x ∈ [0,1] of buying from firm 1 (at 0) -/
noncomputable def cost_from_firm1 (model : LinearCityModel) (x : ℝ) : ℝ :=
  model.p₁ + model.t * x

/-- Total cost to a consumer at location x ∈ [0,1] of buying from firm 2 (at 1) -/
noncomputable def cost_from_firm2 (model : LinearCityModel) (x : ℝ) : ℝ :=
  model.p₂ + model.t * (1 - x)

/-- Net utility of a consumer at location x buying from firm 1 -/
noncomputable def utility_firm1 (model : LinearCityModel) (x : ℝ) : ℝ :=
  model.v - model.cost_from_firm1 x

/-- Net utility of a consumer at location x buying from firm 2 -/
noncomputable def utility_firm2 (model : LinearCityModel) (x : ℝ) : ℝ :=
  model.v - model.cost_from_firm2 x

end LinearCityModel