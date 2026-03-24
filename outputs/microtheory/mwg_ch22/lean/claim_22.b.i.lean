import Mathlib
open Topology

theorem ex_ante_ups_convex {n : ℕ} (S : Set (Fin n → ℝ)) :
    Convex ℝ (convexHull ℝ S) :=
  convex_convexHull ℝ S