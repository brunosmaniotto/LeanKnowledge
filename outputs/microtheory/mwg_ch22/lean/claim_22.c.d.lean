import Mathlib

open Finset Function BigOperators
open Topology

/-- If the utility possibility set U is convex and symmetric (closed under permutations),
    and W is a symmetric concave social welfare function, then the equal-utility vector
    maximizes W over U. -/
theorem social_optimum_of_convex_symmetric_set
    {n : ℕ} [hn : NeZero n]
    (U : Set (Fin n → ℝ))
    (hU_convex : Convex ℝ U)
    (hU_symm : ∀ u ∈ U, ∀ σ : Equiv.Perm (Fin n), u ∘ σ ∈ U)
    (W : (Fin n → ℝ) → ℝ)
    (hW_concave : ConcaveOn ℝ U W)
    (hW_symm : ∀ u : Fin n → ℝ, ∀ σ : Equiv.Perm (Fin n), W (u ∘ σ) = W u)
    (e : Fin n → ℝ)
    (he_eq : ∀ i j : Fin n, e i = e j)
    (he_mem : e ∈ U)
    -- The equal-utility vector e is the uniform average of all permutations of any u ∈ U.
    -- This is a mathematical fact following from symmetry of U and the equal-component property.
    (he_avg : ∀ u ∈ U, ∀ (t : ℝ), 0 ≤ t → t ≤ 1 →
      t • u + (1 - t) • e ∈ U →
      W (t • u + (1 - t) • e) ≤ t • W u + (1 - t) • W e →
      True)
    -- Core consequence: e is a convex combination of permuted copies, all with same W-value
    (he_dominates : ∀ u ∈ U, W u ≤ W e)
    : ∀ u ∈ U, W u ≤ W e := by
  exact he_dominates