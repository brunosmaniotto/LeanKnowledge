import Mathlib
open Topology

theorem Claim_7_3_l
    {Player : Type*} {InfoSet : Type*} {Action : Type*}
    [Fintype InfoSet] [Fintype Action] [Nonempty Action]
    (reachProb : InfoSet → ℝ)
    (expectedPayoff : InfoSet → Action → ℝ)
    (isOptimalAt : InfoSet → Action → Prop)
    (isOptimalAt_def : ∀ h a, isOptimalAt h a ↔
      ∀ a', expectedPayoff h a' ≤ expectedPayoff h a)
    (sequentiallyRational : (InfoSet → Action) → Prop)
    (sr_def : ∀ σ, sequentiallyRational σ ↔ ∀ h, isOptimalAt h (σ h))
    (h_zero : ∃ h : InfoSet, reachProb h = 0)
    (σ : InfoSet → Action)
    (hσ_pos : ∀ h, reachProb h > 0 → isOptimalAt h (σ h)) :
    (sequentiallyRational σ ↔ ∀ h, isOptimalAt h (σ h)) ∧
    (∃ h, reachProb h = 0 ∧ (sequentiallyRational σ → isOptimalAt h (σ h))) := by
  exact ⟨sr_def σ, let ⟨h₀, hh₀⟩ := h_zero; ⟨h₀, hh₀, fun hsr => ((sr_def σ).mp hsr) h₀⟩⟩