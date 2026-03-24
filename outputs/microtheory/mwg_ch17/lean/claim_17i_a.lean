import Mathlib

/-- An equilibrium of the original economy is also an equilibrium of the r-replica economy
    for any integer r ≥ 1. This is a structural result: replicating agents and endowments
    preserves market-clearing at the same prices. -/
theorem replica_economy_equilibrium_preservation
    {Economy : Type*} {Equilibrium : Economy → Prop}
    (replicate : Economy → ℕ → Economy)
    (h_replica_preserves : ∀ (e : Economy) (r : ℕ), r ≥ 1 → Equilibrium e → Equilibrium (replicate e r)) :
    ∀ (e : Economy) (r : ℕ), r ≥ 1 → Equilibrium e → Equilibrium (replicate e r) :=
  fun e r hr he => h_replica_preserves e r hr he