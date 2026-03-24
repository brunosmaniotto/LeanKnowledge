import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Proposition_23C4
    {I : Type*} [Fintype I] [DecidableEq I]
    {Θ : I → Type*} {K : Type*}
    (v : (i : I) → K → Θ i → ℝ)
    (kstar : ((i : I) → Θ i) → K)
    (h_opt : ∀ (θ : (i : I) → Θ i) (k : K),
      ∑ i, v i k (θ i) ≤ ∑ i, v i (kstar θ) (θ i))
    (h : (i : I) → ((j : I) → j ≠ i → Θ j) → ℝ)
    (t : (i : I) → ((j : I) → Θ j) → ℝ)
    (ht : ∀ i (θ : (j : I) → Θ j),
      t i θ = (∑ j ∈ univ.erase i, v j (kstar θ) (θ j)) +
              h i (fun j _ => θ j)) :
    ∀ (i : I) (θ : (j : I) → Θ j) (θ_i' : Θ i),
      v i (kstar (Function.update θ i θ_i')) (θ i) + t i (Function.update θ i θ_i') ≤
      v i (kstar θ) (θ i) + t i θ := by
  intro i θ θ_i'
  set θ' := Function.update θ i θ_i' with hθ'_def
  rw [ht i θ', ht i θ]
  have hupd : ∀ j, j ≠ i → θ' j = θ j := by
    intro j hj; simp [hθ'_def, Function.update_apply, hj]
  have h_eq : (fun j (hj : j ≠ i) => θ' j) = (fun j (hj : j ≠ i) => θ j) := by
    ext j hj; exact hupd j hj
  rw [h_eq]
  have sum_eq : ∑ j ∈ univ.erase i, v j (kstar θ') (θ' j) =
      ∑ j ∈ univ.erase i, v j (kstar θ') (θ j) := by
    apply Finset.sum_congr rfl
    intro j hj
    rw [mem_erase] at hj
    congr 1; exact hupd j hj.1
  rw [sum_eq]
  have total_eq : ∀ k', v i k' (θ i) + ∑ j ∈ univ.erase i, v j k' (θ j) =
      ∑ j, v j k' (θ j) := by
    intro k'
    rw [← Finset.add_sum_erase univ (fun j => v j k' (θ j)) (mem_univ i)]
  linarith [total_eq (kstar θ'), total_eq (kstar θ), h_opt θ (kstar θ')]