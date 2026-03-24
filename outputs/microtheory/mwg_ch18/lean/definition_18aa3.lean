import Mathlib

/-- A game in characteristic form (I, V) is superadditive if for any disjoint coalitions S, T,
    whenever u^S ∈ V(S) and u^T ∈ V(T), the combined payoff vector (u^S, u^T) ∈ V(S ∪ T). -/
def is_superadditive {I : Type*} [Fintype I] [DecidableEq I]
    (V : Finset I → Set (I → ℝ)) : Prop :=
  ∀ S T : Finset I, Disjoint S T →
    ∀ uS uT : I → ℝ,
      uS ∈ V S → uT ∈ V T →
      (fun i => if i ∈ S then uS i else if i ∈ T then uT i else 0) ∈ V (S ∪ T)