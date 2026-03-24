import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Proposition_3_D_1
    {L : ℕ} (hL : 0 < L)
    (p : Fin L → ℝ) (hp : ∀ i, 0 < p i)
    (w : ℝ) (hw : 0 ≤ w)
    (u : (Fin L → ℝ) → ℝ) (hu : Continuous u) :
    ∃ x : Fin L → ℝ, (∀ i, 0 ≤ x i) ∧ (∑ i, p i * x i ≤ w) ∧
      ∀ y : Fin L → ℝ, (∀ i, 0 ≤ y i) → (∑ i, p i * y i ≤ w) → u y ≤ u x := by
  set ub : Fin L → ℝ := fun i => w / p i
  set K := Set.Icc (0 : Fin L → ℝ) ub
  set S := {x : Fin L → ℝ | ∑ i, p i * x i ≤ w}
  set B := K ∩ S
  have hSclosed : IsClosed S :=
    isClosed_le (continuous_finset_sum _ fun i _ => continuous_const.mul (continuous_apply i))
      continuous_const
  have hBcpt : IsCompact B :=
    isCompact_Icc.of_isClosed_subset (isClosed_Icc.inter hSclosed) Set.inter_subset_left
  have hne : (0 : Fin L → ℝ) ∈ B :=
    ⟨⟨le_refl _, fun i => div_nonneg hw (le_of_lt (hp i))⟩, by simp [S, hw]⟩
  obtain ⟨x, hxB, hmax⟩ := hBcpt.exists_isMaxOn ⟨0, hne⟩ hu.continuousOn
  refine ⟨x, hxB.1.1, hxB.2, fun y hy_nn hy_bud => hmax ?_⟩
  refine ⟨⟨hy_nn, fun i => ?_⟩, hy_bud⟩
  by_contra h
  push_neg at h
  have h1 : p i * y i ≤ w :=
    (single_le_sum (fun j _ => mul_nonneg (le_of_lt (hp j)) (hy_nn j)) (mem_univ i)).trans hy_bud
  have h2 : p i * (w / p i) = w := mul_div_cancel₀ w (ne_of_gt (hp i))
  linarith [mul_lt_mul_of_pos_left h (hp i)]