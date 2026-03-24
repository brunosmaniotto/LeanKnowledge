import Mathlib

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {X : Type*}

theorem social_planner_pareto_optimum
    (u : I → X → ℝ) (S : Set X) (W : (I → ℝ) → ℝ)
    (hW : ∀ a b : I → ℝ, (∀ i, a i ≤ b i) → (∃ i, a i < b i) → W a < W b)
    (f : X) (hfS : f ∈ S)
    (hopt : ∀ x ∈ S, W (fun i => u i x) ≤ W (fun i => u i f))
    -- Conclusion: f is Pareto optimal (no feasible x Pareto dominates f)
    : ¬∃ x ∈ S, (∀ i, u i f ≤ u i x) ∧ (∃ i, u i f < u i x) := by
  intro ⟨x, hxS, hdom, hstrict⟩
  have hWlt := hW (fun i => u i f) (fun i => u i x) hdom hstrict
  have hWle := hopt x hxS
  linarith