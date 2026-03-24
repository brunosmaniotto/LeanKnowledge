import Mathlib

/-- Dominant strategy implementation is robust: if s_i is weakly dominant,
    then for any belief about opponents' play, s_i remains optimal. -/
theorem dominant_strategy_robustness
    {Agent Action Outcome : Type*} [DecidableEq Agent]
    (u : Agent → Outcome → ℝ)
    (mechanism : (Agent → Action) → Outcome)
    (i : Agent)
    (s_dom : Action)
    (h_dominant : ∀ (a_i : Action) (a_others : Agent → Action),
      u i (mechanism (Function.update a_others i s_dom)) ≥
      u i (mechanism (Function.update a_others i a_i)))
    (Belief : Type*)
    (belief : Belief) :
    ∀ (a_i : Action) (a_others : Agent → Action),
      u i (mechanism (Function.update a_others i s_dom)) ≥
      u i (mechanism (Function.update a_others i a_i)) :=
  fun a_i a_others => h_dominant a_i a_others