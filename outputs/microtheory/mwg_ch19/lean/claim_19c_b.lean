import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Claim_19C_b
    {S : ℕ}
    (π : Fin S → ℝ)
    (hπ_pos : ∀ s, 0 ≤ π s)
    (u : Fin S → ℝ → ℝ)
    (hu_concave : ∀ s, ConcaveOn ℝ Set.univ (u s))
    (x y : Fin S → ℝ)
    (α : ℝ)
    (hα0 : 0 ≤ α) (hα1 : α ≤ 1)
    (h_pref : ∑ s ∈ Finset.univ, π s * u s (y s) ≤ ∑ s ∈ Finset.univ, π s * u s (x s)) :
    ∑ s ∈ Finset.univ, π s * u s (y s) ≤
      ∑ s ∈ Finset.univ, π s * u s (α * x s + (1 - α) * y s) := by
  have h1α : 0 ≤ 1 - α := sub_nonneg.mpr hα1
  have hsum : α + (1 - α) = 1 := by ring
  -- Concavity gives pointwise bound
  have pointwise : ∀ s, π s * (α * u s (x s) + (1 - α) * u s (y s)) ≤
      π s * u s (α * x s + (1 - α) * y s) := by
    intro s
    have hc := hu_concave s
    have key := hc.2 (Set.mem_univ (x s)) (Set.mem_univ (y s)) hα0 h1α hsum
    simp only [smul_eq_mul] at key
    exact mul_le_mul_of_nonneg_left key (hπ_pos s)
  -- Sum the pointwise bounds
  have sum_bound : ∑ s ∈ Finset.univ, π s * (α * u s (x s) + (1 - α) * u s (y s)) ≤
      ∑ s ∈ Finset.univ, π s * u s (α * x s + (1 - α) * y s) :=
    Finset.sum_le_sum (fun s _ => pointwise s)
  -- Rewrite LHS using ring_nf to avoid pattern mismatch
  have expand : ∑ s ∈ Finset.univ, π s * (α * u s (x s) + (1 - α) * u s (y s)) =
      α * (∑ s ∈ Finset.univ, π s * u s (x s)) + (1 - α) * (∑ s ∈ Finset.univ, π s * u s (y s)) := by
    trans (∑ s ∈ Finset.univ, (α * (π s * u s (x s)) + (1 - α) * (π s * u s (y s))))
    · apply Finset.sum_congr rfl; intros; ring
    · rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum]
  calc ∑ s ∈ Finset.univ, π s * u s (y s)
      = α * (∑ s ∈ Finset.univ, π s * u s (y s)) + (1 - α) * (∑ s ∈ Finset.univ, π s * u s (y s)) := by ring
    _ ≤ α * (∑ s ∈ Finset.univ, π s * u s (x s)) + (1 - α) * (∑ s ∈ Finset.univ, π s * u s (y s)) := by
        linarith [mul_le_mul_of_nonneg_left h_pref hα0]
    _ = ∑ s ∈ Finset.univ, π s * (α * u s (x s) + (1 - α) * u s (y s)) := expand.symm
    _ ≤ ∑ s ∈ Finset.univ, π s * u s (α * x s + (1 - α) * y s) := sum_bound