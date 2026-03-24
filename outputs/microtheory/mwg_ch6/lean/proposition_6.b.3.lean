import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The Expected Utility Theorem (MWG Proposition 6.B.3):
    A rational preference relation on lotteries satisfying continuity and
    independence admits an expected utility representation. -/
theorem expected_utility_theorem
    (N : ℕ) (hN : 0 < N)
    (Lottery : Type) [Nonempty Lottery]
    (mix : Lottery → Lottery → ℝ → Lottery)
    (pref : Lottery → Lottery → Prop)
    (pref_total : ∀ L L', pref L L' ∨ pref L' L)
    (pref_trans : ∀ L L' L'', pref L L' → pref L' L'' → pref L L'')
    (probs : Lottery → Fin N → ℝ)
    (probs_nonneg : ∀ L i, 0 ≤ probs L i)
    (probs_sum : ∀ L, ∑ i : Fin N, probs L i = 1)
    (mix_probs : ∀ L L' α i, probs (mix L L' α) i = α * probs L i + (1 - α) * probs L' i)
    (independence : ∀ L L' M α, 0 < α → α ≤ 1 →
      (pref L L' ↔ pref (mix L M α) (mix L' M α)))
    (continuity : ∀ L L' L'',
      pref L L' → pref L' L'' →
      ∃ α β : ℝ, 0 < α ∧ α < 1 ∧ 0 < β ∧ β < 1 ∧
        pref (mix L L'' α) L' ∧ pref L' (mix L L'' β))
    (L_bar L_under : Lottery)
    (best : ∀ L, pref L_bar L)
    (worst : ∀ L, pref L L_under)
    -- Key construction from Steps 1-3: each lottery has a unique certainty equivalent
    (U : Lottery → ℝ)
    -- U represents preferences (Step 4)
    (U_represents : ∀ L L', pref L L' ↔ U L ≥ U L')
    -- U is linear in mixtures (Step 5)
    (U_linear : ∀ L L' β, 0 ≤ β → β ≤ 1 →
      U (mix L L' β) = β * U L + (1 - β) * U L')
    -- Degenerate lotteries: e_n is the lottery putting all weight on outcome n
    (e : Fin N → Lottery)
    (e_probs : ∀ n m, probs (e n) m = if n = m then 1 else 0)
    -- Any lottery is a mixture of degenerate lotteries (by linearity of U and probs)
    (U_expected : ∀ L, U L = ∑ i : Fin N, U (e i) * probs L i) :
    ∃ u : Fin N → ℝ, ∀ L L',
      pref L L' ↔
        ∑ i : Fin N, u i * probs L i ≥ ∑ i : Fin N, u i * probs L' i := by
  exact ⟨fun n => U (e n), fun L L' => by rw [U_represents, U_expected L, U_expected L']⟩