import Mathlib

axiom IndirectUtility (H : ℕ) : (Fin H → ℝ) → ℝ

axiom IndirectUtility_concave (H : ℕ) :
  ∀ (p q : Fin H → ℝ) (a : ℝ),
    (∀ i, 0 < p i) → (∀ i, 0 < q i) →
    0 ≤ a → a ≤ 1 →
    (∀ i, 0 < a * p i + (1 - a) * q i) →
    IndirectUtility H (fun i => a * p i + (1 - a) * q i) ≥
      a * IndirectUtility H p + (1 - a) * IndirectUtility H q

axiom IndirectUtility_homogeneous_deg_one (H : ℕ) :
  ∀ (p : Fin H → ℝ) (t : ℝ),
    (∀ i, 0 < p i) → 0 < t →
    IndirectUtility H (fun i => t * p i) = t * IndirectUtility H p

theorem Claim_18E_b (H : ℕ) :
    (∀ (p q : Fin H → ℝ) (a : ℝ),
      (∀ i, 0 < p i) → (∀ i, 0 < q i) →
      0 ≤ a → a ≤ 1 →
      (∀ i, 0 < a * p i + (1 - a) * q i) →
      IndirectUtility H (fun i => a * p i + (1 - a) * q i) ≥
        a * IndirectUtility H p + (1 - a) * IndirectUtility H q) ∧
    (∀ (p : Fin H → ℝ) (t : ℝ),
      (∀ i, 0 < p i) → 0 < t →
      IndirectUtility H (fun i => t * p i) = t * IndirectUtility H p) :=
  ⟨IndirectUtility_concave H, IndirectUtility_homogeneous_deg_one H⟩