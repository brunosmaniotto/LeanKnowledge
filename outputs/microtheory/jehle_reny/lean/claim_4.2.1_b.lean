import Mathlib
open BigOperators

variables {J : ℕ} (hJ : J > 0)
variables {a b c : ℝ} (hb_pos : b > 0)

-- Define the output of each firm as a function from firm index to quantity
variables (q : Fin J → ℝ)

-- Define the total output of all firms
def total_output (q_vec : Fin J → ℝ) : ℝ := ∑ j : Fin J, q_vec j

-- Define the Cournot equilibrium condition for a specific firm j