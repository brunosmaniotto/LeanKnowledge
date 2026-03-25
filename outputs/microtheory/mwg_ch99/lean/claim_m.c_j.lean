import Mathlib

open Set
open Topology

theorem concavity_cardinal_quasiconcavity_ordinal :
    (∀ {E : Type*} [AddCommMonoid E] [Module ℝ E]
      (s : Set E) (f : E → ℝ) (g : ℝ → ℝ),
      StrictMono g →
      (∀ c : ℝ, Convex ℝ {x ∈ s | c ≤ f x}) →
      (∀ c : ℝ, Convex ℝ {x ∈ s | c ≤ g (f x)})) ∧
    (∃ (f : ℝ → ℝ) (g : ℝ → ℝ),
      StrictMono g ∧
      ConcaveOn ℝ (Icc (0 : ℝ) 1) f ∧
      ¬ ConcaveOn ℝ (Icc (0 : ℝ) 1) (g ∘ f)) := by
  constructor
  · intro E _ _ s f g hg hf c x hx y hy a b ha hb hab
    simp only [mem_sep_iff] at hx hy ⊢
    obtain ⟨hxs, hcgfx⟩ := hx
    obtain ⟨hys, hcgfy⟩ := hy
    set d := min (f x) (f y)
    have hxd : x ∈ {z ∈ s | d ≤ f z} := ⟨hxs, min_le_left _ _⟩
    have hyd : y ∈ {z ∈ s | d ≤ f z} := ⟨hys, min_le_right _ _⟩
    have hmem := hf d hxd hyd ha hb hab
    simp only [mem_sep_iff] at hmem
    obtain ⟨hms, hdfm⟩ := hmem
    refine ⟨hms, ?_⟩
    have hcd : c ≤ g d := by
      rcases le_total (f x) (f y) with h | h
      · have : d = f x := min_eq_left h
        rw [this]; exact hcgfx
      · have : d = f y := min_eq_right h
        rw [this]; exact hcgfy
    exact le_trans hcd (hg.monotone hdfm)
  · refine ⟨id, fun x => x ^ 3, Odd.strictMono_pow (by norm_num : Odd (3 : ℕ)), ?_, ?_⟩
    · exact concaveOn_id (convex_Icc 0 1)
    · intro h
      have h0 : (0 : ℝ) ∈ Icc (0 : ℝ) 1 := by norm_num
      have h1 : (1 : ℝ) ∈ Icc (0 : ℝ) 1 := by norm_num
      have := h.2 h0 h1 (by norm_num : (0 : ℝ) ≤ 1/2) (by norm_num : (0 : ℝ) ≤ 1/2)
        (by norm_num : (1 : ℝ)/2 + 1/2 = 1)
      simp [Function.comp, id] at this
      norm_num at this