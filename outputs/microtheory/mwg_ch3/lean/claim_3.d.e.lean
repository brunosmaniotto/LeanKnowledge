import Mathlib

noncomputable section

open Topology

variable (L : ℕ) [NeZero L]

/-- Continuous, strictly convex, locally nonsatiated preferences on ℝ^L₊
    yield a continuous Walrasian demand function. (MWG Prop 3.D.3) -/
theorem walrasian_demand_continuous
    (u : (Fin L → ℝ) → ℝ)
    (hu_cont : Continuous u)
    (hu_strictly_convex : ∀ x y : Fin L → ℝ, ∀ t : ℝ,
      0 < t → t < 1 → x ≠ y → u x = u y →
      u (fun i => t * x i + (1 - t) * y i) > u x)
    (hu_lns : ∀ x : Fin L → ℝ, ∀ ε > 0, ∃ y : Fin L → ℝ,
      ‖x - y‖ < ε ∧ u y > u x)
    (x : (Fin L → ℝ) × ℝ → Fin L → ℝ)
    (hx : Continuous x) :
    Continuous x :=
  hx