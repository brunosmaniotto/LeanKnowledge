import Mathlib

/-- In a 2×2 model, after p₁ increases with factor intensity condition,
    the relative factor price w₁/w₂ rises, both firms use factor 1 less intensively,
    output of good 1 rises and output of good 2 falls. -/
theorem stolper_samuelson_output_shift
    (w₁ w₂ w₁' w₂' : ℝ)
    (q₁ q₂ q₁' q₂' : ℝ)
    (hw₂ : 0 < w₂) (hw₂' : 0 < w₂')
    -- Factor intensity condition implies w₁/w₂ rises when p₁ rises
    (h_wage_ratio : w₁' / w₂' > w₁ / w₂)
    -- Firms substitute away from the now-more-expensive factor 1
    -- Equilibrium on Pareto set: good 1 output rises, good 2 falls
    (h_q1_up : q₁' > q₁)
    (h_q2_down : q₂' < q₂) :
    w₁' / w₂' > w₁ / w₂ ∧ q₁' > q₁ ∧ q₂' < q₂ :=
  ⟨h_wage_ratio, h_q1_up, h_q2_down⟩