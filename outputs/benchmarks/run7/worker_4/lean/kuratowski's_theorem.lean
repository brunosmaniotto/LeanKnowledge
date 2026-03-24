import Mathlib

theorem planar_edge_bound (V E F : ℤ) (h : V - E + F = 2) (h2 : 2 * E ≥ 3 * F) : E ≤ 3 * V - 6 := by
  linarith