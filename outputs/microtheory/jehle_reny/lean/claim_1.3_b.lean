import Mathlib
open BigOperators Set Finset
open Topology

theorem Claim_1_3_b {n : ℕ} (p : Fin n → ℝ) (y : ℝ)
    (hp : ∀ i, 0 < p i) (hy : 0 ≤ y) :
    let B := {x : Fin n → ℝ | (∀ i, 0 ≤ x i) ∧ ∑ i, p i * x i ≤ y}
    ((0 : Fin n → ℝ) ∈ B) ∧ IsClosed B ∧ Bornology.IsBounded B ∧ IsCompact B := by
  intro B
  have hsub : B ⊆ pi univ (fun i : Fin n => Icc (0 : ℝ) (y / p i)) := by
    intro x ⟨hnn, hsum⟩ i _
    exact ⟨hnn i, by
      have h1 : p i * x i ≤ ∑ j, p j * x j :=
        single_le_sum (fun j _ => mul_nonneg (hp j).le (hnn j)) (mem_univ i)
      calc x i = 1 / p i * (p i * x i) := by field_simp [(hp i).ne']
        _ ≤ 1 / p i * y := by
            apply mul_le_mul_of_nonneg_left (h1.trans hsum)
            exact div_nonneg one_pos.le (hp i).le
        _ = y / p i := by ring⟩
  have hbox : IsCompact (pi univ (fun i : Fin n => Icc (0 : ℝ) (y / p i))) :=
    isCompact_univ_pi fun _ => isCompact_Icc
  have hB_eq : B = (⋂ i : Fin n, {x : Fin n → ℝ | (0 : ℝ) ≤ x i}) ∩
      {x : Fin n → ℝ | ∑ i, p i * x i ≤ y} := by
    ext x; simp only [B, mem_inter_iff, mem_iInter, mem_setOf_eq]
  have hcl : IsClosed B := by
    rw [hB_eq]
    exact (isClosed_iInter fun i => isClosed_le continuous_const (continuous_apply i)).inter
      (isClosed_le (continuous_finset_sum _ fun i _ => continuous_const.mul (continuous_apply i))
        continuous_const)
  have hcpt : IsCompact B := hbox.of_isClosed_subset hcl hsub
  exact ⟨⟨fun _ => le_refl 0, by simp [hy]⟩, hcl, hcpt.isBounded, hcpt⟩