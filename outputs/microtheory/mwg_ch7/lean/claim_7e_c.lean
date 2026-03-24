import Mathlib
open BigOperators
open Topology

structure NormalFormGame where
  numPlayers : ℕ
  numStrategies : Fin numPlayers → ℕ
  hPos : ∀ i, 0 < numStrategies i

structure MixedStrategy (n : ℕ) (hn : 0 < n) where
  probs : Fin n → ℝ
  nonneg : ∀ j, 0 ≤ probs j
  sum_one : ∑ j : Fin n, probs j = 1

noncomputable def pureToMixed (n : ℕ) (hn : 0 < n) (k : Fin n) : MixedStrategy n hn where
  probs := fun j => if j = k then 1 else 0
  nonneg := by
    intro j
    split_ifs <;> norm_num
  sum_one := by
    have : ∑ j : Fin n, (if j = k then (1 : ℝ) else 0) = 1 := by
      rw [Finset.sum_ite_eq' Finset.univ k (fun _ => (1 : ℝ))]
      simp
    exact this

theorem normal_form_accommodates_mixed_strategies (G : NormalFormGame) (i : Fin G.numPlayers) (s : Fin (G.numStrategies i)) :
    ∃ σ : MixedStrategy (G.numStrategies i) (G.hPos i),
      σ.probs s = 1 ∧ ∀ j, j ≠ s → σ.probs j = 0 := by
  refine ⟨pureToMixed (G.numStrategies i) (G.hPos i) s, ?_, ?_⟩
  · simp [pureToMixed]
  · intro j hj
    simp [pureToMixed, hj]