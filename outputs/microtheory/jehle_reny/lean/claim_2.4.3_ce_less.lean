import Mathlib
open Topology

theorem claim_2_4_3_CE_less
    (u : ℝ → ℝ) (CE EV : ℝ)
    (hu : StrictMono u)
    (h_risk_averse : u CE < u EV) :
    CE < EV := by
  by_contra h
  push_neg at h
  have := hu.monotone h
  linarith