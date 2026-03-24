import Mathlib

open Finset BigOperators
open BigOperators

/-- Type profile excluding agent `i`: assigns a type to each agent `j ≠ i`. -/
def TypeProfileWithout {N : ℕ} (T : Fin N → Type*) (i : Fin N) :=
  (j : {j : Fin N // j ≠ i}) → T j.val

/-- VCG efficient allocations for a mechanism design setting with `N` agents,
    allocation space `X`, type spaces `T j`, and valuations `v j`.
    - `xHat t` is the ex post efficient allocation maximizing Σⱼ vⱼ(x, tⱼ)
    - `xTilde i t₋ᵢ` is the efficient allocation without agent `i`,
      maximizing Σⱼ≠ᵢ vⱼ(x, tⱼ) -/
structure VCGEfficientAllocations (N : ℕ) (X : Type*) (T : Fin N → Type*)
    (v : (j : Fin N) → X → T j → ℝ) where
  /-- Full-society ex post efficient allocation: x̂(t) -/
  xHat : ((j : Fin N) → T j) → X
  /-- x̂(t) maximizes total welfare: Σⱼ vⱼ(x̂(t), tⱼ) ≥ Σⱼ vⱼ(x, tⱼ) for all x ∈ X -/
  xHat_optimal : ∀ (t : (j : Fin N) → T j) (x : X),
    ∑ j : Fin N, v j (xHat t) (t j) ≥ ∑ j : Fin N, v j x (t j)
  /-- Efficient allocation for society without agent i: x̃ᵢ(t₋ᵢ) -/
  xTilde : (i : Fin N) → TypeProfileWithout T i → X
  /-- x̃ᵢ(t₋ᵢ) maximizes welfare excluding agent i:
      Σⱼ≠ᵢ vⱼ(x̃ᵢ(t₋ᵢ), tⱼ) ≥ Σⱼ≠ᵢ vⱼ(x, tⱼ) for all x ∈ X -/
  xTilde_optimal : ∀ (i : Fin N) (t_neg_i : TypeProfileWithout T i) (x : X),
    ∑ j : {j : Fin N // j ≠ i}, v j.val (xTilde i t_neg_i) (t_neg_i j) ≥
    ∑ j : {j : Fin N // j ≠ i}, v j.val x (t_neg_i j)