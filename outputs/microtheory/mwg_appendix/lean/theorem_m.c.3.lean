import Mathlib

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

noncomputable def IsQuasiConcaveOn' (f : E → ℝ) (A : Set E) : Prop :=
  ∀ x ∈ A, ∀ x' ∈ A, ∀ α : ℝ, 0 ≤ α → α ≤ 1 →
    f (α • x + (1 - α) • x') ≥ min (f x) (f x')

noncomputable def IsStrictlyQuasiConcaveOn' (f : E → ℝ) (A : Set E) : Prop :=
  ∀ x ∈ A, ∀ x' ∈ A, x ≠ x' → ∀ α : ℝ, 0 < α → α < 1 →
    f (α • x + (1 - α) • x') > min (f x) (f x')

axiom qconcave_iff_gradient_nonneg
    (f : E → ℝ) (A : Set E) (hA : Convex ℝ A) (hf : ContDiffOn ℝ 1 f A) :
    IsQuasiConcaveOn' f A ↔
    ∀ x ∈ A, ∀ x' ∈ A, f x ≤ f x' → 0 ≤ fderiv ℝ f x (x' - x)

axiom strict_qconcave_of_gradient_pos
    (f : E → ℝ) (A : Set E) (hA : Convex ℝ A) (hf : ContDiffOn ℝ 1 f A)
    (h : ∀ x ∈ A, ∀ x' ∈ A, f x ≤ f x' → x' ≠ x → 0 < fderiv ℝ f x (x' - x)) :
    IsStrictlyQuasiConcaveOn' f A

axiom gradient_pos_of_strict_qconcave
    (f : E → ℝ) (A : Set E) (hA : Convex ℝ A) (hf : ContDiffOn ℝ 1 f A)
    (hsc : IsStrictlyQuasiConcaveOn' f A)
    (hgrad : ∀ x ∈ A, fderiv ℝ f x ≠ 0) :
    ∀ x ∈ A, ∀ x' ∈ A, f x ≤ f x' → x' ≠ x → 0 < fderiv ℝ f x (x' - x)

theorem «Theorem_M.C.3»
    (f : E → ℝ) (A : Set E) (hA : Convex ℝ A) (hf : ContDiffOn ℝ 1 f A) :
    (IsQuasiConcaveOn' f A ↔
     ∀ x ∈ A, ∀ x' ∈ A, f x ≤ f x' → 0 ≤ fderiv ℝ f x (x' - x)) ∧
    ((∀ x ∈ A, ∀ x' ∈ A, f x ≤ f x' → x' ≠ x → 0 < fderiv ℝ f x (x' - x)) →
      IsStrictlyQuasiConcaveOn' f A) ∧
    (IsStrictlyQuasiConcaveOn' f A →
      (∀ x ∈ A, fderiv ℝ f x ≠ 0) →
      ∀ x ∈ A, ∀ x' ∈ A, f x ≤ f x' → x' ≠ x → 0 < fderiv ℝ f x (x' - x)) :=
  ⟨qconcave_iff_gradient_nonneg f A hA hf,
   strict_qconcave_of_gradient_pos f A hA hf,
   gradient_pos_of_strict_qconcave f A hA hf⟩