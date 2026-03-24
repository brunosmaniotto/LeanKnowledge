import Mathlib

/-- An equilibrium price sequence in the OLG model is tatonnement stable at time t
    if an (anticipated) increase in pₜ, all other prices remaining fixed,
    results in excess supply in period t.

    We model this via an `excessDemand` function: given a price sequence,
    it returns the excess demand at each period. The stability condition says
    that increasing pₜ (while holding other prices fixed) makes excess demand
    at period t strictly negative (i.e., excess supply). -/
def OLG.IsTatonnementStableAt
    (excessDemand : (ℕ → ℝ) → ℕ → ℝ)
    (p : ℕ → ℝ)
    (t : ℕ) : Prop :=
  ∀ ε > 0, excessDemand (Function.update p t (p t + ε)) t < 0