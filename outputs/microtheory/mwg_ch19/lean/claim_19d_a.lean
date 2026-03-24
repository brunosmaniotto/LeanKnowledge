import Mathlib
open Topology

theorem arrow_debreu_no_ex_post_trade
    {I S X : Type*} [Nonempty I] [DecidableEq S]
    (u : I → S → X → ℝ)
    (x : I → S → X)
    (feasible : (I → S → X) → Prop)
    (h_feas : ∀ (y : I → X) (s₀ : S), feasible (fun i s => if s = s₀ then y i else x i s))
    (h_pareto : ¬∃ y : I → S → X, feasible y ∧
      (∀ i s, u i s (y i s) ≥ u i s (x i s)) ∧
      (∃ i s, u i s (y i s) > u i s (x i s)))
    (s₀ : S) :
    ¬∃ y : I → X, (∀ i, u i s₀ (y i) ≥ u i s₀ (x i s₀)) ∧
      (∃ i, u i s₀ (y i) > u i s₀ (x i s₀)) := by
  intro ⟨y, hy_all, i₀, hi₀⟩
  apply h_pareto
  refine ⟨fun i s => if s = s₀ then y i else x i s, h_feas y s₀, ?_, ?_⟩
  · intro i s
    by_cases h : s = s₀
    · subst h; simp; exact hy_all i
    · simp [h]
  · exact ⟨i₀, s₀, by simp; exact hi₀⟩