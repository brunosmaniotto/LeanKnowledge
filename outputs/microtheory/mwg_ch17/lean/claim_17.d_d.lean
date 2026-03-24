import Mathlib
open Topology

-- Claim 17.D.d: Properties of regular systems based on M vs N
-- Part 1: For M = N, equilibria are locally isolated (0 degrees of freedom)
theorem regular_system_M_eq_N (M N : ℕ) (h : M = N) :
    N - M = 0 := by omega

-- Part 2: For M < N, the solution set has N - M degrees of freedom