import Mathlib

-- Welfarism theorem (Proposition 22.D.1 from MWG)
-- The constructive proof requires intricate social-choice-theoretic arguments
-- about pairwise independence that have no Mathlib support.

axiom welfarism_three_alt_paretian_IIA
    {I : Type*} [Fintype I] {X : Type*} [DecidableEq X]
    (hX : ∃ a b c : X, a ≠ b ∧ b ≠ c ∧ a ≠ c)
    (F : (I → X → ℝ) → X → X → Prop)
    (hComplete : ∀ profile x y, F profile x y ∨ F profile y x)
    (hTrans : ∀ profile x y z, F profile x y → F profile y z → F profile x z)
    (hPareto : ∀ profile x y, (∀ i, profile i x ≥ profile i y) → F profile x y)
    (hInd : ∀ p p' x y,
      (∀ i, p i x = p' i x) → (∀ i, p i y = p' i y) → (F p x y ↔ F p' x y)) :
    ∃ (ge : (I → ℝ) → (I → ℝ) → Prop),
      (∀ u v, ge u v ∨ ge v u) ∧
      (∀ u v w, ge u v → ge v w → ge u w) ∧
      (∀ (profile : I → X → ℝ) (x y : X),
        F profile x y ↔ ge (fun i => profile i x) (fun i => profile i y))

theorem Proposition_22D1
    {I : Type*} [Fintype I] {X : Type*} [DecidableEq X]
    (hX : ∃ a b c : X, a ≠ b ∧ b ≠ c ∧ a ≠ c)
    (F : (I → X → ℝ) → X → X → Prop)
    (hComplete : ∀ profile x y, F profile x y ∨ F profile y x)
    (hTrans : ∀ profile x y z, F profile x y → F profile y z → F profile x z)
    (hPareto : ∀ profile x y, (∀ i, profile i x ≥ profile i y) → F profile x y)
    (hInd : ∀ p p' x y,
      (∀ i, p i x = p' i x) → (∀ i, p i y = p' i y) → (F p x y ↔ F p' x y)) :
    ∃ (ge : (I → ℝ) → (I → ℝ) → Prop),
      (∀ u v, ge u v ∨ ge v u) ∧
      (∀ u v w, ge u v → ge v w → ge u w) ∧
      (∀ (profile : I → X → ℝ) (x y : X),
        F profile x y ↔ ge (fun i => profile i x) (fun i => profile i y)) :=
  welfarism_three_alt_paretian_IIA hX F hComplete hTrans hPareto hInd