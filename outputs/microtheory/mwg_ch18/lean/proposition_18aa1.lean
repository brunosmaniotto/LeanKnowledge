import Mathlib
open BigOperators

-- A cooperative game with finite player set
structure CooperativeGame (I : Type*) [Fintype I] [DecidableEq I] where
  v : Finset I → ℝ
  v_empty : v ∅ = 0

-- Convexity of a cooperative game
def IsConvex {I : Type*} [Fintype I] [DecidableEq I] (G : CooperativeGame I) : Prop :=
  ∀ S T : Finset I, G.v (S ∪ T) + G.v (S ∩ T) ≥ G.v S + G.v T

-- The Shapley value assigns a payoff to each player
noncomputable def shapley_value {I : Type*} [Fintype I] [DecidableEq I]
    (G : CooperativeGame I) : I → ℝ := by
  intro i
  exact ∑ S ∈ Finset.univ.powerset.filter (fun S => i ∉ S),
    (((Nat.factorial S.card) * (Nat.factorial (Fintype.card I - S.card - 1)) : ℝ) /
     (Nat.factorial (Fintype.card I) : ℝ)) *
    (G.v (S ∪ {i}) - G.v S)

-- A payoff vector is in the core if it is efficient and no coalition can improve