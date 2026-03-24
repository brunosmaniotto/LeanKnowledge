import Mathlib

open Filter Set

-- Let π be the profit function, where π(J) is the profit for each firm if J firms enter.
-- Let K be the fixed cost of entry.
variable {π : ℕ → ℝ} {K : ℝ}

/--
In the two-stage entry model, an equilibrium with `J_star` firms entering is characterized by two
conditions from the problem description:
1. Entrants do not regret entering (and enter when indifferent): `π J_star ≥ K`.
2. Non-entrants do not regret staying out: `π (J_star + 1) < K`.

This definition formalizes the conditions for a Subgame Perfect Nash Equilibrium (SPNE)
in this specific entry model. The first part of the theorem statement is that an equilibrium
exists if and only if these conditions hold, which is true by this definition. The core result
to prove is the existence and uniqueness of such a `J_star` under further assumptions on `π`.
-/
def IsEquilibrium (J_star : ℕ) : Prop :=
  π J_star ≥ K ∧ π (J_star + 1) < K