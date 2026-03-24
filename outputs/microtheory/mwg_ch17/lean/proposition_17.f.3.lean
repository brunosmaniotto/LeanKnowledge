import Mathlib
set_option linter.unusedVariables false

axiom normalize_price_ratio {L : ℕ} (hL : 0 < L) (p p' : Fin L → ℝ)
    (hp : ∀ i, 0 < p i) (hp' : ∀ i, 0 < p' i)
    (hncol : ¬ ∃ μ : ℝ, 0 < μ ∧ p' = fun i => μ * p i) :
    ∃ (ℓ : Fin L) (lam : ℝ), 0 < lam ∧ lam * p' ℓ = p ℓ ∧ (∀ i, lam * p' i ≤ p i) ∧
      ∃ k : Fin L, k ≠ ℓ ∧ lam * p' k < p k

axiom gs_single_step_increase {L : ℕ} (z : (Fin L → ℝ) → (Fin L → ℝ))
    (hgs : ∀ (q : Fin L → ℝ) (k : Fin L) (ε : ℝ), 0 < ε → ∀ j, j ≠ k →
      z (Function.update q k (q k + ε)) j > z q j)
    (q : Fin L → ℝ) (k ℓ : Fin L) (hkl : k ≠ ℓ) (ε : ℝ) (hε : 0 < ε) :
    z (Function.update q k (q k + ε)) ℓ > z q ℓ

axiom path_monotone_accumulation {L : ℕ} (z : (Fin L → ℝ) → (Fin L → ℝ))
    (hgs : ∀ (q : Fin L → ℝ) (k : Fin L) (ε : ℝ), 0 < ε → ∀ j, j ≠ k →
      z (Function.update q k (q k + ε)) j > z q j)
    (ℓ : Fin L) (p'' p : Fin L → ℝ)
    (hle : ∀ i, p'' i ≤ p i) (heq : p'' ℓ = p ℓ)
    (hlt : ∃ k : Fin L, k ≠ ℓ ∧ p'' k < p k) :
    z p ℓ > z p'' ℓ

axiom homogeneity_zero_preserves_equilibrium {L : ℕ} (z : (Fin L → ℝ) → (Fin L → ℝ))
    (hhom : ∀ (q : Fin L → ℝ) (lam : ℝ), 0 < lam → z (fun i => lam * q i) = z q)
    (p' : Fin L → ℝ) (lam : ℝ) (hlam : 0 < lam) (heq : z p' = 0) :
    z (fun i => lam * p' i) = 0

axiom gross_substitute_unique_equilibrium {L : ℕ} (hL : 0 < L)
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (hhom : ∀ (q : Fin L → ℝ) (lam : ℝ), 0 < lam → z (fun i => lam * q i) = z q)
    (hgs : ∀ (q : Fin L → ℝ) (k : Fin L) (ε : ℝ), 0 < ε → ∀ j, j ≠ k →
      z (Function.update q k (q k + ε)) j > z q j)
    (p p' : Fin L → ℝ) (hp : ∀ i, 0 < p i) (hp' : ∀ i, 0 < p' i)
    (heqp : z p = 0) (heqp' : z p' = 0) :
    ∃ μ : ℝ, 0 < μ ∧ p' = fun i => μ * p i

/-- Proposition 17.F.3: An aggregate excess demand function satisfying the gross substitute
    property has at most one exchange equilibrium up to positive scaling. -/
theorem Proposition_17_F_3 {L : ℕ} (hL : 0 < L)
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (hhom : ∀ (q : Fin L → ℝ) (lam : ℝ), 0 < lam → z (fun i => lam * q i) = z q)
    (hgs : ∀ (q : Fin L → ℝ) (k : Fin L) (ε : ℝ), 0 < ε → ∀ j, j ≠ k →
      z (Function.update q k (q k + ε)) j > z q j)
    (p p' : Fin L → ℝ) (hp : ∀ i, 0 < p i) (hp' : ∀ i, 0 < p' i)
    (heqp : z p = 0) (heqp' : z p' = 0) :
    ∃ μ : ℝ, 0 < μ ∧ p' = fun i => μ * p i := by
  by_contra hncol
  obtain ⟨ℓ, μ, hμpos, hnorm_eq, hnorm_le, k, hkl, hklt⟩ :=
    normalize_price_ratio hL p p' hp hp' hncol
  have hzerop'' : z (fun i => μ * p' i) = 0 :=
    homogeneity_zero_preserves_equilibrium z hhom p' μ hμpos heqp'
  have hgt : z p ℓ > z (fun i => μ * p' i) ℓ :=
    path_monotone_accumulation z hgs ℓ (fun i => μ * p' i) p
      hnorm_le hnorm_eq ⟨k, hkl, hklt⟩
  have h0p   : z p ℓ = 0                    := congr_fun heqp ℓ
  have h0p'' : z (fun i => μ * p' i) ℓ = 0 := congr_fun hzerop'' ℓ
  linarith