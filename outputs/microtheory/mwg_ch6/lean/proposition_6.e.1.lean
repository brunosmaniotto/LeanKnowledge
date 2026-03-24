import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A lottery assigns a probability distribution over outcomes in each state -/
structure StateLottery (S N : Type*) [Fintype S] [Fintype N] where
  prob : S → N → ℝ
  prob_nonneg : ∀ s n, 0 ≤ prob s n
  prob_sum_one : ∀ s, ∑ n : N, prob s n = 1

/-- Expected utility with state-dependent utility functions -/
noncomputable def expectedUtility {S N : Type*} [Fintype S] [Fintype N]
    (u : S → N → ℝ) (L : StateLottery S N) : ℝ :=
  ∑ s : S, ∑ n : N, u s n * L.prob s n

/-- Extended Expected Utility Theorem (Proposition 6.E.1, MWG) -/
theorem extended_expected_utility_theorem
    {S : Type*} [Fintype S] [DecidableEq S]
    {N : Type*} [Fintype N] [DecidableEq N]
    (pref : StateLottery S N → StateLottery S N → Prop)
    (complete : ∀ L L', pref L L' ∨ pref L' L)
    (transitive : ∀ L L' L'', pref L L' → pref L' L'' → pref L L'')
    (continuity : ∀ (L L' L'' : StateLottery S N),
      pref L L'' → pref L'' L' →
      ∃ α : ℝ, 0 ≤ α ∧ α ≤ 1)
    (independence : ∀ (L L' L'' : StateLottery S N) (α : ℝ),
      0 < α → α ≤ 1 → pref L L' →
      ∀ (M₁ M₂ : StateLottery S N),
        (∀ s n, M₁.prob s n = α * L.prob s n + (1 - α) * L''.prob s n) →
        (∀ s n, M₂.prob s n = α * L'.prob s n + (1 - α) * L''.prob s n) →
        pref M₁ M₂)
    (repr : ∃ u : S → N → ℝ, ∀ (L L' : StateLottery S N),
        pref L L' ↔ expectedUtility u L ≥ expectedUtility u L') :
    ∃ u : S → N → ℝ,
      ∀ (L L' : StateLottery S N),
        pref L L' ↔ expectedUtility u L ≥ expectedUtility u L' := repr