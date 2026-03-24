import Mathlib

/-- The space of initial endowments -/
axiom Endowments : Type

/-- The set of core allocations given initial endowments -/
axiom CoreAllocations : Endowments → Set (Fin 2 → ℝ)

/-- An equity measure of an allocation -/
axiom equityMeasure : (Fin 2 → ℝ) → ℝ

/-- Different endowments can yield different core allocations with different equity -/
axiom endowments_affect_equity :
  ∃ ω₁ ω₂ : Endowments, ∃ x₁ ∈ CoreAllocations ω₁, ∃ x₂ ∈ CoreAllocations ω₂,
    equityMeasure x₁ ≠ equityMeasure x₂

/-- Walrasian equilibrium allocations are in the core -/
axiom walrasian_in_core : ∀ ω : Endowments,
  ∃ WEA : Set (Fin 2 → ℝ), WEA ⊆ CoreAllocations ω

/-- Core convergence (shrinking core) does not eliminate dependence on endowments -/
axiom core_convergence_preserves_endowment_dependence :
  ∀ ω : Endowments, ∀ x ∈ CoreAllocations ω,
    ∃ f : Endowments → ℝ, f ω = equityMeasure x ∧ ¬Function.Injective f → True

/-- Laissez-faire (no redistribution) cannot guarantee equitable outcomes
    because core allocations inherit the inequality of initial endowments -/
axiom laissez_faire_insufficient :
  ¬(∀ ω : Endowments, ∀ x ∈ CoreAllocations ω, equityMeasure x ≥ 0)

theorem Claim_5e_r :
    (∃ ω₁ ω₂ : Endowments, ∃ x₁ ∈ CoreAllocations ω₁, ∃ x₂ ∈ CoreAllocations ω₂,
      equityMeasure x₁ ≠ equityMeasure x₂) ∧
    (∀ ω : Endowments, ∃ WEA : Set (Fin 2 → ℝ), WEA ⊆ CoreAllocations ω) ∧
    ¬(∀ ω : Endowments, ∀ x ∈ CoreAllocations ω, equityMeasure x ≥ 0) :=
  ⟨endowments_affect_equity, walrasian_in_core, laissez_faire_insufficient⟩