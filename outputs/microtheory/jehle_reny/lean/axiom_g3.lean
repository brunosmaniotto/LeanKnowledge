import Mathlib

/-- Axiom G3 (Continuity): For any gamble g, there exists α ∈ [0,1]
    such that g is indifferent to the lottery (α ∘ a₁, (1-α) ∘ aₙ),
    where a₁ is the best and aₙ the worst outcome.
    `mix α x y` represents the compound lottery giving x with probability α
    and y with probability (1 - α). -/
def MWG.ContinuityAxiom {G : Type*} (indiff : G → G → Prop)
    (mix : ℝ → G → G → G) (a₁ aₙ : G) : Prop :=
  ∀ g : G, ∃ α : ℝ, 0 ≤ α ∧ α ≤ 1 ∧ indiff g (mix α a₁ aₙ)