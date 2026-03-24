import Mathlib
open BigOperators Finset
open Topology

theorem Proposition_22D3
    {I : Type*} [Fintype I] [DecidableEq I] [Nonempty I]
    (b : I → ℝ)
    (hb_nonneg : ∀ i, 0 ≤ b i)
    (hb_pos : ∃ i, 0 < b i)
    (h_unit_inv : ∀ (u v : I → ℝ) (sc : I → ℝ),
      (∀ i, 0 < sc i) →
      (∑ i, b i * u i > ∑ i, b i * v i ↔
       ∑ i, b i * (sc i * u i) > ∑ i, b i * (sc i * v i)))
    : ∃ h : I, 0 < b h ∧ ∀ j : I, j ≠ h → b j = 0 := by
  obtain ⟨h, hh⟩ := hb_pos
  refine ⟨h, hh, ?_⟩
  intro j hj
  by_contra hbj
  have hbj_pos : 0 < b j := lt_of_le_of_ne (hb_nonneg j) (Ne.symm hbj)
  have hjh : h ≠ j := Ne.symm hj
  let u : I → ℝ := fun i => if i = j then 1 else if i = h then -(b j / (2 * b h)) else 0
  let v : I → ℝ := fun _ => 0
  have hv : ∑ i, b i * v i = 0 := by simp [v]
  have key1 : ∀ i, b i * u i = if i = j then b j else if i = h then -(b j / 2) else 0 := by
    intro i; simp only [u]; split_ifs with h1 h2
    · subst h1; ring
    · subst h2; field_simp
    · ring
  have hu_sum : ∑ i, b i * u i = b j / 2 := by
    simp_rw [key1]
    rw [← Finset.add_sum_erase univ (fun i => if i = j then b j else if i = h then -(b j / 2) else 0) (mem_univ j)]
    simp only [if_true]
    have hj_mem : h ∈ univ.erase j := by simp [hjh]
    rw [← Finset.add_sum_erase _ _ hj_mem]
    simp only [if_neg hjh, if_true]
    have : ∑ x ∈ (univ.erase j).erase h, (if x = j then b j else if x = h then -(b j / 2) else 0) = 0 := by
      apply Finset.sum_eq_zero; intro x hx
      simp only [mem_erase] at hx
      simp [hx.1, hx.2.1]
    rw [this]; ring
  have h_gt : ∑ i, b i * u i > ∑ i, b i * v i := by
    rw [hu_sum, hv]; linarith
  let sc : I → ℝ := fun i => if i = j then (1 : ℝ) / 4 else 1
  have hsc : ∀ i, 0 < sc i := by
    intro i; simp only [sc]; split_ifs <;> positivity
  have key2 : ∀ i, b i * (sc i * u i) = if i = j then b j / 4 else if i = h then -(b j / 2) else 0 := by
    intro i; simp only [sc, u]; split_ifs with h1 h2
    · subst h1; ring
    · subst h2; field_simp
    · ring
  have hsc_sum : ∑ i, b i * (sc i * u i) = -(b j / 4) := by
    simp_rw [key2]
    rw [← Finset.add_sum_erase univ (fun i => if i = j then b j / 4 else if i = h then -(b j / 2) else 0) (mem_univ j)]
    simp only [if_true]
    have hj_mem : h ∈ univ.erase j := by simp [hjh]
    rw [← Finset.add_sum_erase _ _ hj_mem]
    simp only [if_neg hjh, if_true]
    have : ∑ x ∈ (univ.erase j).erase h, (if x = j then b j / 4 else if x = h then -(b j / 2) else 0) = 0 := by
      apply Finset.sum_eq_zero; intro x hx
      simp only [mem_erase] at hx
      simp [hx.1, hx.2.1]
    rw [this]; ring
  have hscv : ∑ i, b i * (sc i * v i) = 0 := by simp [v]
  have h_scaled := (h_unit_inv u v sc hsc).mp h_gt
  rw [hscv] at h_scaled
  linarith [hsc_sum]