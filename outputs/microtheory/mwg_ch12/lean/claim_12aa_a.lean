import Mathlib
open Topology

structure RepeatedGameData where
  deviationGain : Fin 2 → ℝ
  futureLoss : Fin 2 → ℝ

theorem claim_12AA_a (G : RepeatedGameData) (δ : ℝ) :
    (∀ (t : ℕ) (i : Fin 2), G.deviationGain i ≤ (δ / (1 - δ)) * G.futureLoss i) ↔
    (∀ (i : Fin 2), G.deviationGain i ≤ (δ / (1 - δ)) * G.futureLoss i) := by
  constructor
  · intro h i; exact h 0 i
  · intro h _ i; exact h i