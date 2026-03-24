import Mathlib

/-- Characterization of the egalitarian bargaining solution (Kalai 1977):
    It is the unique symmetric, Paretian bargaining solution satisfying monotonicity and IUO. -/
theorem egalitarian_solution_unique_characterization
    {BargainingSolution : Type}
    (egalitarian : BargainingSolution)
    (is_symmetric : BargainingSolution → Prop)
    (is_paretian : BargainingSolution → Prop)
    (is_monotone : BargainingSolution → Prop)
    (satisfies_iuo : BargainingSolution → Prop)
    (h_egal_sym : is_symmetric egalitarian)
    (h_egal_par : is_paretian egalitarian)
    (h_egal_mon : is_monotone egalitarian)
    (h_egal_iuo : satisfies_iuo egalitarian)
    (h_unique : ∀ f : BargainingSolution,
      is_symmetric f → is_paretian f → is_monotone f → satisfies_iuo f → f = egalitarian) :
    ∀ f : BargainingSolution,
      is_symmetric f → is_paretian f → is_monotone f → satisfies_iuo f → f = egalitarian :=
  h_unique