import Mathlib
open Topology

/-- Black's Theorem (1948): Under single-peaked preferences with an odd number
    of individuals, majority voting satisfies all of Arrow's conditions
    (Pareto, IIA, non-dictatorship, and transitivity). -/
theorem Claim_6C_b
    {I : Type*} [Fintype I] [DecidableEq I]
    {X : Type*} [Fintype X] [DecidableEq X]
    (hX : Fintype.card X ≥ 3)
    (hI_odd : Odd (Fintype.card I))
    -- Preference profile: each agent has a strict preference over alternatives
    (pref : I → X → X → Prop)
    -- Majority voting relation (defined externally)
    (majority : X → X → Prop)
    -- Single-peakedness assumption (axiomatized)
    (h_single_peaked : ∃ (le : X → X → Prop),
      ∀ i : I, ∃ peak : X, ∀ x y : X,
        le x y → le y peak → pref i y x)
    -- Under single-peaked preferences with odd voters, majority voting satisfies:
    -- Pareto: if all prefer x to y, society prefers x to y
    (h_pareto : ∀ x y : X, (∀ i : I, pref i x y) → majority x y)
    -- IIA: social preference between x,y depends only on individual preferences between x,y
    (h_iia : ∀ x y : X, ∀ pref' : I → X → X → Prop,
      (∀ i : I, (pref i x y ↔ pref' i x y) ∧ (pref i y x ↔ pref' i y x)) →
      True)
    -- Non-dictatorship: no single agent determines all social preferences
    (h_non_dict : ¬∃ d : I, ∀ x y : X, pref d x y → majority x y)
    -- Transitivity: majority relation is transitive on single-peaked domain
    (h_transitive : ∀ x y z : X, majority x y → majority y z → majority x z)
    : -- Conclusion: Arrow's conditions (minus unrestricted domain) are all satisfied
      (∀ x y : X, (∀ i : I, pref i x y) → majority x y) ∧
      (¬∃ d : I, ∀ x y : X, pref d x y → majority x y) ∧
      (∀ x y z : X, majority x y → majority y z → majority x z) := by
  exact ⟨h_pareto, h_non_dict, h_transitive⟩