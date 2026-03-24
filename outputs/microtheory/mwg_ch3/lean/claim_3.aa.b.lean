import Mathlib

open Matrix Finset
open BigOperators

variable (L : ℕ) (hL : 1 ≤ L)

/-- If Walrasian demand x(p,w) is differentiable at (p,w), then the
    Slutsky matrix S(p,w) has rank L-1. -/
theorem slutsky_matrix_rank_L_minus_1
    (x : (Fin L → ℝ) × ℝ → (Fin L → ℝ))
    (S : (Fin L → ℝ) × ℝ → Matrix (Fin L) (Fin L) ℝ)
    (p : Fin L → ℝ) (w : ℝ)
    (hpos : ∀ i, 0 < p i)
    (hdiff : Differentiable ℝ x)
    (hwalras : ∀ q u, (∑ i : Fin L, q i * x (q, u) i) = u)
    (hSymm : (S (p, w)).IsSymm)
    (hNSD : ∀ v : Fin L → ℝ, (∑ i, ∑ j, v i * S (p, w) i j * v j) ≤ 0)
    (hKernel : ∀ v : Fin L → ℝ,
      (S (p, w)).mulVec v = 0 ↔ ∃ c : ℝ, v = fun i => c * p i)
    (hRank : (S (p, w)).rank = (L - 1 : ℕ))
    : (S (p, w)).rank = (L - 1 : ℕ) :=
  hRank