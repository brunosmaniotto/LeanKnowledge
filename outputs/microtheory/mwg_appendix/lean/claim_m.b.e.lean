import Mathlib
open Topology

theorem claim_M_B_e {X : Type*} {f : X → ℝ} {h : ℝ → ℝ}
    (hh : StrictMono h) (x y : X) :
    h (f x) ≤ h (f y) ↔ f x ≤ f y :=
  hh.le_iff_le