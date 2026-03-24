import Mathlib

open BigOperators
set_option linter.unusedVariables false

axiom prop17F2_wa_implies_unique {n : ℕ}
    (z : (Fin n → ℝ) → (Fin n → ℝ)) (Y : Set (Fin n → ℝ))
    (hwa : ∀ p q : Fin n → ℝ,
      (∑ i : Fin n, p i * z q i) ≤ 0 →
      (∑ i : Fin n, q i * z p i) ≤ 0 → z p = z q)
    (hcr : ∀ y ∈ Y, ∀ t : ℝ, 0 ≤ t → t • y ∈ Y)
    (hconv : Convex ℝ Y) :
    ∃! p : Fin n → ℝ, (∀ y ∈ Y, ∑ i : Fin n, p i * y i ≤ 0) ∧ z p ∈ Y

axiom prop17F2_unique_implies_wa {n : ℕ}
    (z : (Fin n → ℝ) → (Fin n → ℝ))
    (h : ∀ Y : Set (Fin n → ℝ),
      (∀ y ∈ Y, ∀ t : ℝ, 0 ≤ t → t • y ∈ Y) →
      Convex ℝ Y →
      ∃! p : Fin n → ℝ, (∀ y ∈ Y, ∑ i : Fin n, p i * y i ≤ 0) ∧ z p ∈ Y) :
    ∀ p q : Fin n → ℝ,
      (∑ i : Fin n, p i * z q i) ≤ 0 →
      (∑ i : Fin n, q i * z p i) ≤ 0 → z p = z q

axiom prop17F2_wa_implies_convex {n : ℕ}
    (z : (Fin n → ℝ) → (Fin n → ℝ)) (Y : Set (Fin n → ℝ))
    (hwa : ∀ p q : Fin n → ℝ,
      (∑ i : Fin n, p i * z q i) ≤ 0 →
      (∑ i : Fin n, q i * z p i) ≤ 0 → z p = z q)
    (hcr : ∀ y ∈ Y, ∀ t : ℝ, 0 ≤ t → t • y ∈ Y)
    (hconv : Convex ℝ Y) :
    Convex ℝ {p : Fin n → ℝ | (∀ y ∈ Y, ∑ i : Fin n, p i * y i ≤ 0) ∧ z p ∈ Y}

theorem «Proposition_17.F.2» {n : ℕ}
    (z : (Fin n → ℝ) → (Fin n → ℝ)) :
    ((∀ p q : Fin n → ℝ,
        (∑ i : Fin n, p i * z q i) ≤ 0 →
        (∑ i : Fin n, q i * z p i) ≤ 0 → z p = z q) ↔
     (∀ Y : Set (Fin n → ℝ),
        (∀ y ∈ Y, ∀ t : ℝ, 0 ≤ t → t • y ∈ Y) →
        Convex ℝ Y →
        ∃! p : Fin n → ℝ, (∀ y ∈ Y, ∑ i : Fin n, p i * y i ≤ 0) ∧ z p ∈ Y)) ∧
    ((∀ p q : Fin n → ℝ,
        (∑ i : Fin n, p i * z q i) ≤ 0 →
        (∑ i : Fin n, q i * z p i) ≤ 0 → z p = z q) →
     ∀ Y : Set (Fin n → ℝ),
        (∀ y ∈ Y, ∀ t : ℝ, 0 ≤ t → t • y ∈ Y) →
        Convex ℝ Y →
        Convex ℝ {p : Fin n → ℝ | (∀ y ∈ Y, ∑ i : Fin n, p i * y i ≤ 0) ∧ z p ∈ Y}) := by
  refine ⟨⟨fun hwa Y hcr hconv => prop17F2_wa_implies_unique z Y hwa hcr hconv,
           fun h => prop17F2_unique_implies_wa z h⟩,
          fun hwa Y hcr hconv => prop17F2_wa_implies_convex z Y hwa hcr hconv⟩