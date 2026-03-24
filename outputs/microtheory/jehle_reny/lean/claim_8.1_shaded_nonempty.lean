import Mathlib
open Topology

/-- The shaded region of feasible low-risk separating policies is always non-empty
    because MRS_l(0,0) > π (the low-risk fair premium rate). -/
theorem shaded_region_nonempty
    (π MRS_l : ℝ)
    (h : MRS_l > π) :
    Set.Nonempty {α : ℝ | π < α ∧ α < MRS_l} :=
  ⟨(π + MRS_l) / 2, by constructor <;> linarith⟩