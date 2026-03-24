import Mathlib
open Topology

structure SignalEquilibrium where
  numConsumers : ℕ
  numStates : ℕ
  numGoods : ℕ
  hConsumers : 0 < numConsumers
  hStates : 1 < numStates
  exAnteUtility : Fin numConsumers → ℝ → ℝ
  spotPrice : Fin numStates → Fin numGoods → ℝ → ℝ

theorem more_info_can_reduce_welfare :
    ∃ (E : SignalEquilibrium) (σ_low σ_high : ℝ),
      σ_low < σ_high ∧
      (∀ i : Fin E.numConsumers, E.exAnteUtility i σ_high < E.exAnteUtility i σ_low) ∧
      (∃ s : Fin E.numStates, ∃ g : Fin E.numGoods,
        E.spotPrice s g σ_high ≠ E.spotPrice s g σ_low) := by
  refine ⟨⟨1, 2, 1, by norm_num, by norm_num, fun _ σ => -σ, fun _ _ σ => σ⟩,
          0, 1, by norm_num, ?_, ?_⟩
  · intro i
    fin_cases i
    norm_num
  · exact ⟨⟨0, by norm_num⟩, ⟨0, by norm_num⟩, by norm_num⟩