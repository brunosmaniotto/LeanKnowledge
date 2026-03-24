import Mathlib

noncomputable section

/-- With a continuum of consumers whose values have continuous distribution G,
    average demand for the indivisible good at price p is 1 - G(p),
    which is continuous. -/
theorem Example_4AA1
    (G : ℝ → ℝ)
    (hG_cont : Continuous G)
    (avg_demand : ℝ → ℝ)
    (h_avg : avg_demand = fun p => 1 - G p) :
    Continuous avg_demand := by
  rw [h_avg]
  exact continuous_const.sub hG_cont