import Mathlib

open Matrix

structure TwoPlayerStrategicFormGame where
  Player1Strategies : Type
  Player2Strategies : Type
  payoff1 : Player1Strategies → Player2Strategies → ℝ
  payoff2 : Player1Strategies → Player2Strategies → ℝ

theorem Claim_7_2_b (G : TwoPlayerStrategicFormGame)
    [Fintype G.Player1Strategies] [Fintype G.Player2Strategies] :
    ∃ (M1 : Matrix G.Player1Strategies G.Player2Strategies ℝ)
      (M2 : Matrix G.Player1Strategies G.Player2Strategies ℝ),
      ∀ (s1 : G.Player1Strategies) (s2 : G.Player2Strategies),
        M1 s1 s2 = G.payoff1 s1 s2 ∧ M2 s1 s2 = G.payoff2 s1 s2 := by
  refine ⟨G.payoff1, G.payoff2, λ s1 s2 => ⟨rfl, rfl⟩⟩