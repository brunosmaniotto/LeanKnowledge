import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem asset_demand_expected_utility_concave
    {S : Type*} [Fintype S]
    {N : Type*} [Fintype N]
    (p : S → ℝ) (hp_nonneg : ∀ s, 0 ≤ p s)
    (z : N → S → ℝ)
    (u : ℝ → ℝ)
    (hu_concave : ConcaveOn ℝ Set.univ u) :
    ConcaveOn ℝ Set.univ
      (fun α : N → ℝ => ∑ s : S, p s * u (∑ i : N, α i * z i s)) := by
  refine ⟨convex_univ, fun α _ β _ a b ha hb hab => ?_⟩
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  have key : ∀ s : S,
      (∑ i : N, (a * α i + b * β i) * z i s) =
      a * (∑ i, α i * z i s) + b * (∑ i, β i * z i s) := by
    intro s
    have : ∀ i, (a * α i + b * β i) * z i s = a * (α i * z i s) + b * (β i * z i s) :=
      fun i => by ring
    simp_rw [this, sum_add_distrib, ← mul_sum]
  simp_rw [key]
  rw [mul_sum, mul_sum, ← sum_add_distrib]
  apply sum_le_sum
  intro s _
  have eq : a * (p s * u (∑ i, α i * z i s)) + b * (p s * u (∑ i, β i * z i s))
      = p s * (a * u (∑ i, α i * z i s) + b * u (∑ i, β i * z i s)) := by ring
  rw [eq]
  apply mul_le_mul_of_nonneg_left _ (hp_nonneg s)
  have := hu_concave.2 (Set.mem_univ (∑ i, α i * z i s)) (Set.mem_univ (∑ i, β i * z i s)) ha hb hab
  simpa [smul_eq_mul] using this