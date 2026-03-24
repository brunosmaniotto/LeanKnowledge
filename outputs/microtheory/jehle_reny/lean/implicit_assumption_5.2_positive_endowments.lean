import Mathlib

open BigOperators Finset

/-- The aggregate endowment is strictly positive in every component:
    Σ_i e_i(ℓ) > 0 for all goods ℓ. Required for existence of
    Walrasian equilibrium (Theorems 5.3–5.5). -/
def AggregateEndowmentStrictlyPositive
    {I : Type*} [Fintype I]
    {L : ℕ}
    (e : I → Fin L → ℝ) : Prop :=
  ∀ l : Fin L, 0 < ∑ i : I, e i l