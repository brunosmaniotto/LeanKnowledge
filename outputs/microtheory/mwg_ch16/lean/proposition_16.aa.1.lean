import Mathlib

open Set Finset BigOperators
open Topology
open BigOperators

theorem Proposition_16_AA_1
    {n : ℕ}
    {I : Type*} [Fintype I] [Nonempty I]
    {J : Type*} [Fintype J]
    (X : I → Set (EuclideanSpace ℝ (Fin n)))
    (Y : J → Set (EuclideanSpace ℝ (Fin n)))
    (ω : EuclideanSpace ℝ (Fin n))
    (Ysum : Set (EuclideanSpace ℝ (Fin n)))
    (A : Set (EuclideanSpace ℝ (Fin n)))
    (hX_closed : ∀ i, IsClosed (X i))
    (hY_closed : ∀ j, IsClosed (Y j))
    (hYsum_convex : Convex ℝ Ysum)
    (hYsum_inaction : (0 : EuclideanSpace ℝ (Fin n)) ∈ Ysum)
    (hYsum_closed : IsClosed Ysum)
    (hA_closed : IsClosed A)
    (hA_bdd : Bornology.IsBounded A)
    (hY_neg_orthant : ∀ v : EuclideanSpace ℝ (Fin n),
      (∀ k, EuclideanSpace.equiv (Fin n) ℝ v k ≤ 0) → v ∈ Ysum)
    (x_bar : I → EuclideanSpace ℝ (Fin n))
    (hx_bar_mem : ∀ i, x_bar i ∈ X i)
    (hx_bar_feas : ∀ k, ∑ i, EuclideanSpace.equiv (Fin n) ℝ (x_bar i) k
      ≤ EuclideanSpace.equiv (Fin n) ℝ ω k)
    (hA_of_feas : (∑ i, x_bar i - ω) ∈ Ysum → (∀ i, x_bar i ∈ X i) → A.Nonempty) :
    (IsClosed A ∧ Bornology.IsBounded A) ∧ A.Nonempty := by
  refine ⟨⟨hA_closed, hA_bdd⟩, ?_⟩
  apply hA_of_feas
  · apply hY_neg_orthant
    intro k
    have h1 : (EuclideanSpace.equiv (Fin n) ℝ) (∑ i, x_bar i - ω) k =
      (∑ i, (EuclideanSpace.equiv (Fin n) ℝ) (x_bar i) k) -
      (EuclideanSpace.equiv (Fin n) ℝ) ω k := by
      simp [map_sub, map_sum, Finset.sum_apply]
    rw [h1]
    linarith [hx_bar_feas k]
  · exact hx_bar_mem