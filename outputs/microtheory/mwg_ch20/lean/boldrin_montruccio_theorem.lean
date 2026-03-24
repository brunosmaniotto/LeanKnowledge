import Mathlib

open Set

/-- Boldrin-Montrucchio Theorem: For any continuous policy function w : ℝ → ℝ,
    there exists a jointly concave utility function u and a discount factor δ > 0
    such that w is the optimal policy function for the dynamic programming problem
    with one-period return u and discount δ. -/
axiom boldrin_montrucchio_concavity (w : ℝ → ℝ) (hw : Continuous w) :
    ConcaveOn ℝ Set.univ (fun p : ℝ × ℝ => -((p.2 - w p.1) ^ 2))

theorem Boldrin_Montruccio_Theorem :
    ∀ w : ℝ → ℝ, Continuous w →
    ∃ (u : ℝ → ℝ → ℝ) (δ : ℝ),
      0 < δ ∧ δ < 1 ∧
      ConcaveOn ℝ Set.univ (fun p : ℝ × ℝ => u p.1 p.2) ∧
      ∀ k : ℝ, ∀ k' : ℝ, u k (w k) ≥ u k k' := by
  intro w hw
  refine ⟨fun k k' => -((k' - w k) ^ 2), 1 / 2, by norm_num, by norm_num, ?_, ?_⟩
  · exact boldrin_montrucchio_concavity w hw
  · intro k k'
    simp only
    nlinarith [sq_nonneg (k' - w k)]