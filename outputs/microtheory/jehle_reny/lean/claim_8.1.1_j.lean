import Mathlib

open Set

/-- A nondecreasing function from a closed interval [a,b] to itself has a fixed point.
    We prove this via the sup argument: p* = sSup {p | p ≤ g(p)} is a fixed point. -/
theorem Claim_8_1_1_j
    (πL : ℝ) (hπL : 0 ≤ πL)
    (g : ℝ → ℝ)
    (g_maps : ∀ p, p ∈ Icc 0 πL → g p ∈ Icc 0 πL)
    (g_mono : ∀ p q, p ∈ Icc 0 πL → q ∈ Icc 0 πL → p ≤ q → g p ≤ g q)
    : ∃ p_star ∈ Icc 0 πL, g p_star = p_star := by
  -- Define S = {p ∈ [0, πL] | p ≤ g(p)}
  set S := {p ∈ Icc 0 πL | p ≤ g p} with hS_def
  -- S is nonempty: 0 ∈ S since 0 ≤ g(0)
  have h0_mem : (0 : ℝ) ∈ S := by
    simp only [hS_def, mem_sep_iff, mem_Icc]
    exact ⟨⟨le_refl 0, hπL⟩, (g_maps 0 ⟨le_refl 0, hπL⟩).1⟩
  -- S is bounded above by πL
  have hS_bdd : BddAbove S := ⟨πL, fun p hp => hp.1.2⟩
  -- Let p* = sSup S
  set p_star := sSup S with hp_star_def
  have hS_ne : S.Nonempty := ⟨0, h0_mem⟩
  -- p* ∈ [0, πL]
  have hp_star_mem : p_star ∈ Icc 0 πL := by
    constructor
    · exact le_csSup_of_le hS_bdd h0_mem (by linarith [h0_mem.1.1])
    · exact csSup_le hS_ne (fun p hp => hp.1.2)
  -- p* ≤ g(p*): for all p ∈ S, p ≤ g(p) ≤ g(p*) by monotonicity, so p* = sup S ≤ g(p*)
  have h_le : p_star ≤ g p_star := by
    apply csSup_le hS_ne
    intro p hp
    have hp_le_ps : p ≤ p_star := le_csSup hS_bdd hp
    calc p ≤ g p := hp.2
    _ ≤ g p_star := g_mono p p_star hp.1 hp_star_mem hp_le_ps
  -- g(p*) ≤ p*: since p* ≤ g(p*), by monotonicity g(p*) ≤ g(g(p*)),
  -- so g(p*) ∈ S, hence g(p*) ≤ sup S = p*
  have h_ge : g p_star ≤ p_star := by
    have hgp_mem : g p_star ∈ Icc 0 πL := g_maps p_star hp_star_mem
    have hgp_in_S : g p_star ∈ S := by
      refine ⟨hgp_mem, ?_⟩
      exact g_mono p_star (g p_star) hp_star_mem hgp_mem h_le
    exact le_csSup_of_le hS_bdd hgp_in_S (le_refl _)
  exact ⟨p_star, hp_star_mem, le_antisymm h_ge h_le⟩