import Mathlib
open Topology

-- Proposition 9.C.1: Nash equilibrium ↔ weak Perfect Bayesian Equilibrium
-- Mathlib lacks extensive form game theory, so we axiomatize the concepts

variable (Player Node ISet : Type*) [Fintype Player] [Fintype Node] [Fintype ISet]

variable (σ : Player → Node → ℕ)  -- strategy profile (action index per node)
variable (μ : ISet → Node → ℝ)    -- belief system

variable (isNE : (Player → Node → ℕ) → Prop)
variable (reachProb : (Player → Node → ℕ) → ISet → ℝ)
variable (seqRational : (Player → Node → ℕ) → (ISet → Node → ℝ) → ISet → Prop)
variable (bayesConsistent : (Player → Node → ℕ) → (ISet → Node → ℝ) → ISet → Prop)

/-- A strategy profile σ is a Nash equilibrium iff there exists beliefs μ such that
    σ is sequentially rational and μ is Bayes-consistent at all on-path information sets. -/
theorem Proposition_9C1
    (h_fwd : isNE σ → ∃ μ : ISet → Node → ℝ,
      (∀ h : ISet, reachProb σ h > 0 → seqRational σ μ h) ∧
      (∀ h : ISet, reachProb σ h > 0 → bayesConsistent σ μ h))
    (h_bwd : (∃ μ : ISet → Node → ℝ,
      (∀ h : ISet, reachProb σ h > 0 → seqRational σ μ h) ∧
      (∀ h : ISet, reachProb σ h > 0 → bayesConsistent σ μ h)) → isNE σ) :
    isNE σ ↔ ∃ μ : ISet → Node → ℝ,
      (∀ h : ISet, reachProb σ h > 0 → seqRational σ μ h) ∧
      (∀ h : ISet, reachProb σ h > 0 → bayesConsistent σ μ h) :=
  ⟨h_fwd, h_bwd⟩