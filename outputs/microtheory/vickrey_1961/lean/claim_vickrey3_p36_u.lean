import Mathlib

open MeasureTheory ENNReal
open Topology

-- `μ_v1` is a measure (e.g., probability distribution) on ℝ.
-- `y2(x)` is a function mapping bidder 1's bid `x` to the second highest bid.
noncomputable def expected_payment_by_bidder_1 (μ_v1 : Measure ℝ) (y2 : ℝ → ℝ)
    (h_y2_measurable : Measurable y2)
    (h_integrable : Integrable (fun x : ℝ => y2 x * x) μ_v1) : ℝ :=
  ∫ (x : ℝ), y2 x * x ∂μ_v1