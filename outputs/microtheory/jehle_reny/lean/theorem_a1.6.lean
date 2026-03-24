import Mathlib

open Metric Set
open Topology
open List

theorem theorem_A1_6
    {m n : ℕ}
    (D : Set (EuclideanSpace ℝ (Fin m)))
    (f : EuclideanSpace ℝ (Fin m) → EuclideanSpace ℝ (Fin n)) :
    TFAE [
      ContinuousOn f D,
      ∀ (c : EuclideanSpace ℝ (Fin n)) (r : ℝ),
        ∃ U, IsOpen U ∧ D ∩ f ⁻¹' (ball c r) = D ∩ U,
      ∀ S, IsOpen S → ∃ U, IsOpen U ∧ D ∩ f ⁻¹' S = D ∩ U
    ] := by
  tfae_have 1 → 3 := by
    intro hcont S hS
    have hcr := continuousOn_iff_continuous_restrict.mp hcont
    have hpre := continuous_def.mp hcr S hS
    rw [isOpen_induced_iff] at hpre
    obtain ⟨U, hU, hUeq⟩ := hpre
    refine ⟨U, hU, ?_⟩
    ext x; simp only [mem_inter_iff, mem_preimage]; constructor
    · rintro ⟨hxD, hfx⟩
      have h1 : (⟨x, hxD⟩ : D) ∈ D.restrict f ⁻¹' S := hfx
      rw [← hUeq] at h1
      exact ⟨hxD, h1⟩
    · rintro ⟨hxD, hxU⟩
      have h1 : (⟨x, hxD⟩ : D) ∈ Subtype.val ⁻¹' U := hxU
      rw [hUeq] at h1
      exact ⟨hxD, h1⟩
  tfae_have 3 → 2 := fun h c r => h _ isOpen_ball
  tfae_have 2 → 1 := by
    intro h2
    rw [Metric.continuousOn_iff]
    intro x hxD ε hε
    obtain ⟨U, hU, hUeq⟩ := h2 (f x) ε
    have hx : x ∈ D ∩ f ⁻¹' ball (f x) ε := ⟨hxD, mem_ball_self hε⟩
    rw [hUeq] at hx
    obtain ⟨_, hxU⟩ := hx
    obtain ⟨δ, hδ, hball⟩ := Metric.isOpen_iff.mp hU x hxU
    exact ⟨δ, hδ, fun y hyD hyx => by
      have : y ∈ D ∩ U := ⟨hyD, hball (mem_ball.mpr hyx)⟩
      rw [← hUeq] at this
      exact this.2⟩
  tfae_finish