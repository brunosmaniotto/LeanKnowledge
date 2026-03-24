import Mathlib

open BigOperators

/-- Recursive type of gambles over outcomes `A`.
    Base case `outcome` represents G₀ = A.
    Recursive case `compound` represents Gⱼ: a lottery (p₁∘g₁,…,pₖ∘gₖ)
    with k ≥ 1, pᵢ ≥ 0, Σ pᵢ = 1, and each gᵢ a gamble from Gⱼ₋₁. -/
inductive Gamble (A : Type*) where
  | outcome : A → Gamble A
  | compound {k : ℕ} (hk : 0 < k) (p : Fin k → ℝ) (g : Fin k → Gamble A)
      (hp_nonneg : ∀ i, 0 ≤ p i) (hp_sum : ∑ i, p i = 1) : Gamble A

/-- The set of all gambles G = ⋃_{j=0}^∞ G_j over outcomes A,
    encompassing both simple and compound gambles. -/
def AllGambles (A : Type*) := Gamble A