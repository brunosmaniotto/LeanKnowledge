import Mathlib
open Topology

/-- When F is uniform on [0,1], p* = L is always an equilibrium:
    h(L) = [u(w)−u(w−L)]/[u(w)−u(w−L)] = 1, so g(L) = (1+1)·L/2 = L. -/
theorem claim_8_1_1_o
    (L : ℝ)
    (h : ℝ → ℝ)
    (g : ℝ → ℝ)
    (hh_at_L : h L = 1)
    (hg_def : g L = (1 + h L) * L / 2) :
    g L = L := by
  rw [hg_def, hh_at_L]
  ring