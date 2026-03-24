import Mathlib

noncomputable def IsWeakPBE {X H : Type*}
    (infoSet     : H → Set X)
    (reachProb   : (H → ℝ) → X → ℝ)
    (infoSetProb : (H → ℝ) → H → ℝ)
    (seqRational : (H → ℝ) → (X → ℝ) → Prop)
    (σ : H → ℝ) (μ : X → ℝ) : Prop :=
  seqRational σ μ ∧
  ∀ h : H, 0 < infoSetProb σ h →
    ∀ x ∈ infoSet h, μ x = reachProb σ x / infoSetProb σ h

theorem weakPBE_iff {X H : Type*}
    (infoSet     : H → Set X)
    (reachProb   : (H → ℝ) → X → ℝ)
    (infoSetProb : (H → ℝ) → H → ℝ)
    (seqRational : (H → ℝ) → (X → ℝ) → Prop)
    (σ : H → ℝ) (μ : X → ℝ) :
    IsWeakPBE infoSet reachProb infoSetProb seqRational σ μ ↔
    (seqRational σ μ ∧
     ∀ h : H, 0 < infoSetProb σ h →
       ∀ x ∈ infoSet h, μ x = reachProb σ x / infoSetProb σ h) :=
  Iff.rfl