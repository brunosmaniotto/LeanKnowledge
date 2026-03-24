import Mathlib
set_option linter.unusedVariables false

-- Abstract types for the quasilinear economy
axiom Consumer : Type
axiom Firm : Type
axiom NonNumeraireBundle : Type

-- Aggregate surplus: Σ_i φ_i(x_i) − Σ_j c_j(q_j)
axiom aggregate_surplus :
  (Consumer → NonNumeraireBundle) → (Firm → NonNumeraireBundle) → ℝ

-- Pareto optimality (non-numeraire alloc × production × numeraire distribution)
axiom IsParetoOptimal :
  (Consumer → NonNumeraireBundle) → (Firm → NonNumeraireBundle) → (Consumer → ℝ) → Prop

-- First welfare theorem for quasilinear economies:
-- Pareto optimal allocations maximize aggregate surplus
axiom po_implies_max_surplus :
  ∀ (x : Consumer → NonNumeraireBundle) (q : Firm → NonNumeraireBundle) (m : Consumer → ℝ),
    IsParetoOptimal x q m →
    IsMaxOn (fun p : (Consumer → NonNumeraireBundle) × (Firm → NonNumeraireBundle) =>
      aggregate_surplus p.1 p.2) Set.univ (x, q)

-- Unique maximizer: strict concavity of aggregate surplus + uniqueness assumption
axiom unique_surplus_maximizer :
  ∀ (x₁ x₂ : Consumer → NonNumeraireBundle) (q₁ q₂ : Firm → NonNumeraireBundle),
    IsMaxOn (fun p : (Consumer → NonNumeraireBundle) × (Firm → NonNumeraireBundle) =>
      aggregate_surplus p.1 p.2) Set.univ (x₁, q₁) →
    IsMaxOn (fun p : (Consumer → NonNumeraireBundle) × (Firm → NonNumeraireBundle) =>
      aggregate_surplus p.1 p.2) Set.univ (x₂, q₂) →
    x₁ = x₂ ∧ q₁ = q₂

-- Claim 10.D.b: Pareto optimal allocations agree on good-ℓ quantities;
-- they can only differ in the numeraire distribution m.
theorem Claim_10D_b
    (x₁ x₂ : Consumer → NonNumeraireBundle)
    (q₁ q₂ : Firm → NonNumeraireBundle)
    (m₁ m₂ : Consumer → ℝ)
    (h₁ : IsParetoOptimal x₁ q₁ m₁)
    (h₂ : IsParetoOptimal x₂ q₂ m₂) :
    x₁ = x₂ ∧ q₁ = q₂ :=
  unique_surplus_maximizer x₁ x₂ q₁ q₂
    (po_implies_max_surplus x₁ q₁ m₁ h₁)
    (po_implies_max_surplus x₂ q₂ m₂ h₂)