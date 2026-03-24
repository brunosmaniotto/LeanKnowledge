import Mathlib
open BigOperators

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {Θ : I → Type*} [∀ i, Fintype (Θ i)]
variable {X : Type*}

/-- Expected utility given a profile function for others -/
noncomputable def expUtil
    (u : ∀ i, X → Θ i → ℝ)
    (μ : (∀ i, Θ i) → ℝ)
    (i : I) (θ_i : Θ i) (outcome : (∀ i, Θ i) → X) : ℝ :=
  ∑ θ : ∀ i, Θ i, μ θ * u i (outcome θ) θ_i

/-- A mechanism implements f in BNE -/
structure ImplementsBNE
    (S : I → Type*) [∀ i, Fintype (S i)]
    (g : (∀ i, S i) → X)
    (f : (∀ i, Θ i) → X)
    (u : ∀ i, X → Θ i → ℝ)
    (μ : (∀ i, Θ i) → ℝ) where
  s_star : ∀ i, Θ i → S i
  outcome_eq : ∀ θ : ∀ i, Θ i, g (fun i => s_star i (θ i)) = f θ
  is_bne : ∀ (i : I) (θ_i : Θ i) (s_i' : S i),
    expUtil u μ i θ_i (fun θ => g (Function.update (fun j => s_star j (θ j)) i (s_star i θ_i))) ≥
    expUtil u μ i θ_i (fun θ => g (Function.update (fun j => s_star j (θ j)) i s_i'))

/-- Truthful implementability: the direct mechanism with identity strategies is a BNE -/
def TruthfullyImplementable
    (f : (∀ i, Θ i) → X)
    (u : ∀ i, X → Θ i → ℝ)
    (μ : (∀ i, Θ i) → ℝ) : Prop :=
  ∀ (i : I) (θ_i : Θ i) (θ_i' : Θ i),
    expUtil u μ i θ_i (fun θ => f (Function.update θ i θ_i)) ≥
    expUtil u μ i θ_i (fun θ => f (Function.update θ i θ_i'))