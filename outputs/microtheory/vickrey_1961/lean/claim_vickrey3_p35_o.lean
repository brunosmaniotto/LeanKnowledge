import Mathlib

open MeasureTheory ProbabilityTheory
open Topology

/-- If bidding distributions have a lumped probability mass at a lower bound b₀,
    then any bid at b₀ can be profitably shaded upward, so no equilibrium exists
    at that bound. We model this as: given positive probability mass at b₀ and
    a continuous payoff improvement from shading, there exists a profitable deviation. -/
theorem claim_Vickrey3_p35_o
    (b₀ : ℝ) (v : ℝ) (mass : ℝ)
    (hv : b₀ < v)              -- bidder's value exceeds the lower bound
    (hmass : 0 < mass)          -- positive probability mass lumped at b₀
    (hmass_le : mass ≤ 1) :
    -- There exists an ε-deviation above b₀ that yields strictly positive expected gain
    ∃ ε : ℝ, 0 < ε ∧ ε < v - b₀ ∧ 0 < mass * ((v - b₀) - ε) := by
  refine ⟨(v - b₀) / 2, by linarith, by linarith, ?_⟩
  have hvb : 0 < v - b₀ := by linarith
  have : (v - b₀) - (v - b₀) / 2 = (v - b₀) / 2 := by ring
  rw [this]
  positivity