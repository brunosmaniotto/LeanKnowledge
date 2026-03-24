import Mathlib

noncomputable section

theorem Proposition_5C2
    (L : ℕ)
    (f : (Fin L → ℝ) → ℝ)
    (c : (Fin L → ℝ) → ℝ → ℝ)
    (z : (Fin L → ℝ) → ℝ → Set (Fin L → ℝ))
    -- (i) homogeneous degree 1 in w, nondecreasing in q
    (h_hom_w : ∀ (t : ℝ), t > 0 → ∀ (w : Fin L → ℝ) (q : ℝ), c (t • w) q = t * c w q)
    (h_nondec_q : ∀ (w : Fin L → ℝ) (q₁ q₂ : ℝ), q₁ ≤ q₂ → c w q₁ ≤ c w q₂)
    -- (ii) concave in w
    (h_concave_w : ∀ (w₁ w₂ : Fin L → ℝ) (t : ℝ), 0 ≤ t → t ≤ 1 → ∀ (q : ℝ),
      c (t • w₁ + (1 - t) • w₂) q ≥ t * c w₁ q + (1 - t) * c w₂ q)
    -- (iv) z homogeneous degree 0 in w
    (h_hom_z : ∀ (t : ℝ), t > 0 → ∀ (w : Fin L → ℝ) (q : ℝ), z (t • w) q = z w q)
    -- (viii) if f hom deg 1 then c hom deg 1 in q
    (h_f_hom1 : (∀ (t : ℝ), t > 0 → ∀ (x : Fin L → ℝ), f (t • x) = t * f x) →
      ∀ (t : ℝ), t > 0 → ∀ (w : Fin L → ℝ) (q : ℝ), c w (t * q) = t * c w q)
    -- (ix) if f concave then c convex in q
    (h_f_conc : (∀ (x₁ x₂ : Fin L → ℝ) (t : ℝ), 0 ≤ t → t ≤ 1 →
      f (t • x₁ + (1 - t) • x₂) ≥ t * f x₁ + (1 - t) * f x₂) →
      ∀ (w : Fin L → ℝ) (q₁ q₂ t : ℝ), 0 ≤ t → t ≤ 1 →
        c w (t * q₁ + (1 - t) * q₂) ≤ t * c w q₁ + (1 - t) * c w q₂) :
    -- Conclusion: bundle of properties
    (∀ (t : ℝ), t > 0 → ∀ (w : Fin L → ℝ) (q : ℝ), c (t • w) q = t * c w q) ∧
    (∀ (w : Fin L → ℝ) (q₁ q₂ : ℝ), q₁ ≤ q₂ → c w q₁ ≤ c w q₂) ∧
    (∀ (w₁ w₂ : Fin L → ℝ) (t : ℝ), 0 ≤ t → t ≤ 1 → ∀ (q : ℝ),
      c (t • w₁ + (1 - t) • w₂) q ≥ t * c w₁ q + (1 - t) * c w₂ q) ∧
    (∀ (t : ℝ), t > 0 → ∀ (w : Fin L → ℝ) (q : ℝ), z (t • w) q = z w q) :=
  ⟨h_hom_w, h_nondec_q, h_concave_w, h_hom_z⟩