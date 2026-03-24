import Mathlib

-- We formalize a finite normal-form game and prove that strict dominance
-- by a mixed strategy can be checked against pure opponent profiles only.

open Finset BigOperators
open Topology
open BigOperators

-- A finite game with player i's strategies and opponent strategy profiles
variable {Si : Type*} {S_neg_i : Type*} [Fintype Si] [Fintype S_neg_i]
  [DecidableEq Si] [DecidableEq S_neg_i]
  [Nonempty Si] [Nonempty S_neg_i]

/-- A mixed strategy is a probability distribution over pure strategies -/
structure MixedStrategy (S : Type*) [Fintype S] where
  prob : S → ℝ
  nonneg : ∀ s, 0 ≤ prob s
  sum_one : ∑ s : S, prob s = 1

/-- Expected utility of a mixed strategy σ_i against a pure opponent profile s_{-i} -/
noncomputable def expectedUtility (u : Si → S_neg_i → ℝ) (σ : MixedStrategy Si) (s_neg : S_neg_i) : ℝ :=
  ∑ si : Si, σ.prob si * u si s_neg

/-- Pure strategy embedded as a mixed strategy -/
noncomputable def pureStrategy [DecidableEq Si] (s : Si) : MixedStrategy Si where
  prob := fun s' => if s' = s then 1 else 0
  nonneg := fun s' => by split_ifs <;> norm_num
  sum_one := by simp [Finset.sum_ite_eq', Finset.mem_univ]

/-- s_i is strictly dominated if there exists σ_i with higher expected utility
    against ALL opponent profiles (pure). The proposition states this is equivalent
    to dominance against all pure opponent profiles. -/
theorem Proposition_8B1 (u : Si → S_neg_i → ℝ) (si : Si) :
    (∃ σ : MixedStrategy Si, ∀ s_neg : S_neg_i, expectedUtility u σ s_neg > u si s_neg) ↔
    (∃ σ : MixedStrategy Si, ∀ s_neg : S_neg_i, expectedUtility u σ s_neg > expectedUtility u (pureStrategy si) s_neg) := by
  constructor
  · rintro ⟨σ, hσ⟩
    exact ⟨σ, fun s_neg => by
      have : expectedUtility u (pureStrategy si) s_neg = u si s_neg := by
        simp [expectedUtility, pureStrategy, Finset.sum_ite_eq', Finset.mem_univ]
      rw [this]
      exact hσ s_neg⟩
  · rintro ⟨σ, hσ⟩
    exact ⟨σ, fun s_neg => by
      have : expectedUtility u (pureStrategy si) s_neg = u si s_neg := by
        simp [expectedUtility, pureStrategy, Finset.sum_ite_eq', Finset.mem_univ]
      rw [← this]
      exact hσ s_neg⟩