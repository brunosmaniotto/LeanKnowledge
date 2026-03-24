import Mathlib

open Set InnerProductSpace
open Topology

theorem claim_A2_5_e
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]
    (A : Set E) (hA_convex : Convex ℝ A) (hA_closed : IsClosed A)
    (hA_int : (interior A).Nonempty)
    (a_star : E) (ha_star : a_star ∈ frontier A) :
    ∃ p : E, ‖p‖ = 1 ∧ ∀ a ∈ A, @inner ℝ E _ p a ≥ @inner ℝ E _ p a_star := by
  -- a_star is not in the interior of A (from frontier = closure \ interior)
  have ha_not_int : a_star ∉ interior A := ha_star.2
  -- Separate a_star from the open convex set interior(A) via geometric Hahn-Banach
  obtain ⟨f, hf⟩ := geometric_hahn_banach_open_point hA_convex.interior isOpen_interior ha_not_int
  -- f ≠ 0 (strict inequality on nonempty interior gives contradiction with f = 0)
  have hf_ne : f ≠ 0 := by
    intro hf0; obtain ⟨a, ha⟩ := hA_int
    have := hf a ha; rw [hf0] at this; simp at this
  -- Extend from interior(A) to all of A: f y ≤ f a_star for y ∈ A
  -- Uses: closure(interior A) = closure A for convex sets with nonempty interior
  have hle : ∀ y ∈ A, f y ≤ f a_star := by
    intro y hy
    have hcl := hA_convex.closure_interior_eq_closure_of_nonempty_interior hA_int
    have hym : y ∈ closure (interior A) := hcl ▸ subset_closure hy
    exact closure_minimal (fun a ha => (hf a ha).le)
      (isClosed_le f.continuous continuous_const) hym
  -- Riesz representation: get vector q with ⟪q, x⟫ = f x for all x
  set q := (toDual ℝ E).symm f
  have hq_inner : ∀ x, @inner ℝ E _ q x = f x := by
    intro x
    show @inner ℝ E _ ((toDual ℝ E).symm f) x = f x
    rw [← toDual_apply (𝕜 := ℝ), LinearIsometryEquiv.apply_symm_apply]
  -- q ≠ 0 since f ≠ 0
  have hq_ne : q ≠ 0 := by
    intro heq; apply hf_ne; ext x
    have := hq_inner x; rw [heq, inner_zero_left] at this; simpa using this.symm
  have hq_pos : (0 : ℝ) < ‖q‖ := norm_pos_iff.mpr hq_ne
  -- Take p̂ = -q/‖q‖: reverses the functional direction and normalizes
  -- From f(a) ≤ f(a*) i.e. ⟪q,a⟫ ≤ ⟪q,a*⟫, negation gives ⟪-q,a⟫ ≥ ⟪-q,a*⟫
  refine ⟨‖q‖⁻¹ • (-q), ?_, ?_⟩
  · rw [norm_smul, norm_inv, norm_norm, norm_neg, inv_mul_cancel₀ (ne_of_gt hq_pos)]
  · intro a ha
    simp only [real_inner_smul_left, inner_neg_left]
    have h := hle a ha
    rw [← hq_inner a, ← hq_inner a_star] at h
    nlinarith [inv_nonneg.mpr (norm_nonneg q)]