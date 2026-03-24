import Mathlib
open Topology

/-- If both firms in the Cournot duopoly act as Stackelberg leaders, each assuming
    the other will be a follower, the outcome is inconsistent: neither firm is
    best-responding to the other's leader quantity. -/
theorem Exercise_4_10_b (a b : ℝ) (ha : 0 < a) (hb : 0 < b) :
    let leader_q := a / (2 * b)
    let best_response (qj : ℝ) := (a - b * qj) / (2 * b)
    best_response leader_q ≠ leader_q := by
  simp only
  intro h
  have hb_ne : (b : ℝ) ≠ 0 := ne_of_gt hb
  field_simp at h
  nlinarith