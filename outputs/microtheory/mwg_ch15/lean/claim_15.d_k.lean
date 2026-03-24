import Mathlib
open Topology

theorem pareto_set_factor_intensity_monotonicity
    (κ₁ κ₂ : ℝ → ℝ)
    (hcont₁ : Continuous κ₁) (hcont₂ : Continuous κ₂)
    (hne : ∀ t ∈ Set.Icc (0 : ℝ) 1, κ₁ t ≠ κ₂ t)
    : (∀ t ∈ Set.Icc (0 : ℝ) 1, κ₁ t < κ₂ t) ∨
      (∀ t ∈ Set.Icc (0 : ℝ) 1, κ₂ t < κ₁ t) := by
  by_contra h
  push_neg at h
  obtain ⟨t₁, ht₁mem, ht₁⟩ := h.1
  obtain ⟨t₂, ht₂mem, ht₂⟩ := h.2
  have hne₁ : κ₁ t₁ ≠ κ₂ t₁ := hne t₁ ht₁mem
  have hne₂ : κ₁ t₂ ≠ κ₂ t₂ := hne t₂ ht₂mem
  have h₁ : κ₂ t₁ < κ₁ t₁ := lt_of_le_of_ne ht₁ (Ne.symm hne₁)
  have h₂ : κ₁ t₂ < κ₂ t₂ := lt_of_le_of_ne ht₂ hne₂
  set f := fun t => κ₁ t - κ₂ t
  have hf_cont : ContinuousOn f (Set.Icc 0 1) := (hcont₁.sub hcont₂).continuousOn
  have hf_pos : 0 < f t₁ := by simp [f]; linarith
  have hf_neg : f t₂ < 0 := by simp [f]; linarith
  have h01 : (0 : ℝ) ≤ 1 := by norm_num
  -- Use intermediate_value_uIcc
  have ht₁_01 : t₁ ∈ Set.Icc (0 : ℝ) 1 := ht₁mem
  have ht₂_01 : t₂ ∈ Set.Icc (0 : ℝ) 1 := ht₂mem
  have hconn : IsPreconnected (Set.Icc (0 : ℝ) 1) := isPreconnected_Icc
  have hmem : (0 : ℝ) ∈ Set.Icc (f t₁) (f t₂) ∨ (0 : ℝ) ∈ Set.Icc (f t₂) (f t₁) := by
    right; exact ⟨le_of_lt hf_neg, le_of_lt hf_pos⟩
  obtain ⟨c, hcmem, hceq⟩ : ∃ c ∈ Set.Icc (0 : ℝ) 1, f c = 0 := by
    have : IsPreconnected (f '' Set.Icc (0 : ℝ) 1) :=
      hconn.image f hf_cont
    have hft₁ : f t₁ ∈ f '' Set.Icc (0 : ℝ) 1 := Set.mem_image_of_mem f ht₁mem
    have hft₂ : f t₂ ∈ f '' Set.Icc (0 : ℝ) 1 := Set.mem_image_of_mem f ht₂mem
    have h0mem : (0 : ℝ) ∈ f '' Set.Icc (0 : ℝ) 1 := by
      rw [isPreconnected_iff_ordConnected] at this
      have : Set.OrdConnected (f '' Set.Icc (0 : ℝ) 1) := this
      apply this.out hft₂ hft₁
      constructor <;> linarith
    exact h0mem
  have : κ₁ c = κ₂ c := by simp [f] at hceq; linarith
  exact absurd this (hne c hcmem)