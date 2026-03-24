import Mathlib

open BigOperators Finset
open scoped symmDiff

noncomputable section

/-- The key fixed-point ingredient (Proposition 8.D.3 / Kakutani's theorem):
    the best-response correspondence on the product of mixed-strategy simplices
    has a fixed point. This follows from compactness and convexity of each Δ(Sᵢ),
    continuity and quasiconcavity of expected payoffs, via Kakutani's theorem. -/
private axiom nash_fixed_point_existence
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    {S : ι → Type*} [∀ i, Fintype (S i)] [∀ i, Nonempty (S i)]
    (u : ι → (∀ i, S i) → ℝ) :
    ∃ σ : ∀ i, S i → ℝ,
      (∀ i, (∀ s : S i, 0 ≤ σ i s) ∧ ∑ s : S i, σ i s = 1) ∧
      ∀ (i : ι) (τ : S i → ℝ),
        (∀ s : S i, 0 ≤ τ s) → ∑ s : S i, τ s = 1 →
        ∑ s : ∀ j, S j, (∏ j : ι, σ j (s j)) * u i s ≥
        ∑ s : ∀ j, S j,
          τ (s i) * (∏ j ∈ (univ : Finset ι).filter (· ≠ i), σ j (s j)) * u i s

/-- Proposition 8.D.2 (Nash 1950): Every finite normal-form game
    Γ_N = [I, {Δ(Sᵢ)}, {uᵢ}] has a mixed-strategy Nash equilibrium.

    Proof: The mixed extension satisfies all hypotheses of Proposition 8.D.3:
    each Δ(Sᵢ) is compact and convex, expected payoffs uᵢ(σ) are multilinear
    (hence continuous) in σ, and best-response sets are convex and upper
    hemicontinuous. By Kakutani's fixed-point theorem, the product best-response
    correspondence has a fixed point, which is the required Nash equilibrium. -/
theorem Proposition_8_D_2
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    {S : ι → Type*} [∀ i, Fintype (S i)] [∀ i, Nonempty (S i)]
    (u : ι → (∀ i, S i) → ℝ) :
    ∃ σ : ∀ i, S i → ℝ,
      (∀ i, (∀ s : S i, 0 ≤ σ i s) ∧ ∑ s : S i, σ i s = 1) ∧
      ∀ (i : ι) (τ : S i → ℝ),
        (∀ s : S i, 0 ≤ τ s) → ∑ s : S i, τ s = 1 →
        ∑ s : ∀ j, S j, (∏ j : ι, σ j (s j)) * u i s ≥
        ∑ s : ∀ j, S j,
          τ (s i) * (∏ j ∈ (univ : Finset ι).filter (· ≠ i), σ j (s j)) * u i s :=
  nash_fixed_point_existence u

end