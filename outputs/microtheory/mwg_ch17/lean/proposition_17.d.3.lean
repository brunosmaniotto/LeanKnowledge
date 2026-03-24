import Mathlib

open Set Function MeasureTheory

/-- The Transversality Theorem (Proposition 17.D.3):
If the total derivative Df(v; q) has rank M whenever f(v; q) = 0,
then for almost every q, the partial derivative D_v f(v; q) has rank M
whenever f(v; q) = 0. -/
axiom Proposition_17D3_TransversalityTheorem
    {M N S : ℕ}
    (f : (Fin N → ℝ) → (Fin S → ℝ) → (Fin M → ℝ))
    (hf_smooth : ContDiff ℝ ⊤ (fun p : (Fin N → ℝ) × (Fin S → ℝ) => f p.1 p.2))
    (hDf_rank : ∀ v q, f v q = 0 →
      (fderiv ℝ (fun p : (Fin N → ℝ) × (Fin S → ℝ) => f p.1 p.2) (v, q)).range = ⊤)
    : ∃ (A : Set (Fin S → ℝ)),
        volume Aᶜ = 0 ∧
        ∀ q ∈ A, ∀ v, f v q = 0 →
          (fderiv ℝ (fun v' => f v' q) v).range = ⊤

theorem Proposition_17D3_corollary
    {M N S : ℕ} (hMN : N < M)
    (f : (Fin N → ℝ) → (Fin S → ℝ) → (Fin M → ℝ))
    (hf_smooth : ContDiff ℝ ⊤ (fun p : (Fin N → ℝ) × (Fin S → ℝ) => f p.1 p.2))
    (hDf_rank : ∀ v q, f v q = 0 →
      (fderiv ℝ (fun p : (Fin N → ℝ) × (Fin S → ℝ) => f p.1 p.2) (v, q)).range = ⊤)
    : ∃ (A : Set (Fin S → ℝ)),
        volume Aᶜ = 0 ∧
        ∀ q ∈ A, ∀ v, f v q = 0 →
          (fderiv ℝ (fun v' => f v' q) v).range = ⊤ :=
  Proposition_17D3_TransversalityTheorem f hf_smooth hDf_rank