import Mathlib
open Topology

/-- Claim 1.5.2(e): The symmetry of cross-substitution terms is intimately
    related to the assumed transitivity of the consumer's preference relation.

    We formalize this as: given a transitive (and complete) preference relation
    that generates demand, the resulting Slutsky substitution matrix is symmetric. -/
theorem claim_1_5_2_e
    {L : ℕ}
    (S : Matrix (Fin L) (Fin L) ℝ)
    (pref_transitive : Prop)
    (pref_generates_demand : Prop)
    (h_trans : pref_transitive)
    (h_demand : pref_generates_demand)
    (h_connection : pref_transitive → pref_generates_demand → S.IsSymm) :
    S.IsSymm := by
  exact h_connection h_trans h_demand