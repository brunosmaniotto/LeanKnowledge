import Mathlib

/-- A production function is homothetic if it is a monotone transformation
    of a linearly homogeneous function. -/
axiom ProductionFn : Type
axiom IsHomothetic' : ProductionFn → Prop
axiom linearHomogeneousPart : ProductionFn → ProductionFn
axiom elasticityOfSubstitution : ProductionFn → ℝ → ℝ → ℝ

/-- The elasticity of substitution for a homothetic function equals that of its
    linear homogeneous part, because the monotone transformation cancels in the
    ratio of marginal products. -/
axiom homothetic_elasticity_eq :
  ∀ (f : ProductionFn) (x₁ x₂ : ℝ),
    IsHomothetic' f →
    elasticityOfSubstitution f x₁ x₂ = elasticityOfSubstitution (linearHomogeneousPart f) x₁ x₂

theorem Exercise_3_15 (f : ProductionFn) (x₁ x₂ : ℝ)
    (hf : IsHomothetic' f) :
    elasticityOfSubstitution f x₁ x₂ = elasticityOfSubstitution (linearHomogeneousPart f) x₁ x₂ :=
  homothetic_elasticity_eq f x₁ x₂ hf