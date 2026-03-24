import Mathlib

-- Axiomatized sub-lemmas as provided in the problem description.
-- Note: In a real Mathlib proof, we would use `Continuous.intervalIntegrable` and
-- `integral_interval_add_interval` directly instead of declaring axioms.

axiom continuous_implies_interval_integrable (f : ℝ → ℝ) (hf : Continuous f) (u v : ℝ) :
  IntervalIntegrable f MeasureTheory.volume u v

axiom integral_add_adjacent_intervals_for_integrable (f : ℝ → ℝ) (a b c : ℝ)
  (hac : IntervalIntegrable f MeasureTheory.volume a c)
  (hcb : IntervalIntegrable f MeasureTheory.volume c b) :
  ∫ t in a..c, f t + ∫ t in c..b, f t = ∫ t in a..b, f t

-- Main theorem: Sum of Integrals on Adjacent Intervals for Continuous Functions
-- We prove this using the axiomatized sub-lemmas.
theorem sum_of_integrals_on_adjacent_intervals_for_continuous_functions
    (f : ℝ → ℝ) (hf : Continuous f) (a b c : ℝ) :
    ∫ t in a..c, f t + ∫ t in c..b, f t = ∫ t in a..b, f t := by
  -- From the hypothesis that `f` is continuous, we can use the first axiom
  -- to show that `f` is integrable on the intervals [a, c] and [c, b].
  have hac : IntervalIntegrable f MeasureTheory.volume a c :=
    continuous_implies_interval_integrable f hf a c
  have hcb : IntervalIntegrable f MeasureTheory.volume c b :=
    continuous_implies_interval_integrable f hf c b

  -- With the integrability conditions established, we can apply the second axiom,
  -- which directly proves the desired equality.
  exact integral_add_adjacent_intervals_for_integrable f a b c hac hcb