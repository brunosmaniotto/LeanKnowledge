import Mathlib
open Topology

theorem claim_6C_d (ui_x ui_y uj_x uj_y : ℝ) (ai aj b : ℝ) (hb : b > 0) :
    ui_y - ui_x ≥ uj_x - uj_y ↔
    (ai + b * ui_y) - (ai + b * ui_x) ≥ (aj + b * uj_x) - (aj + b * uj_y) := by
  constructor <;> intro h <;> nlinarith