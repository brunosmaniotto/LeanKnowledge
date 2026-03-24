import Mathlib
open Topology

theorem Claim_14C_b
    (π' : ℝ → ℝ)
    (g_e : ℝ → ℝ → ℝ)
    (θ_H θ_L : ℝ)
    (e_H e_L : ℝ)
    (hθ : θ_H > θ_L)
    (he_H_pos : e_H > 0)
    (he_L_pos : e_L > 0)
    (foc_H : π' e_H = g_e e_H θ_H)
    (foc_L : π' e_L = g_e e_L θ_L)
    (hπ_dec : StrictAntiOn π' (Set.Ioi 0))
    (hg_inc_e : ∀ θ, StrictMonoOn (g_e · θ) (Set.Ioi 0))
    (hg_dec_θ : ∀ e, e > 0 → StrictAntiOn (g_e e) (Set.Ioi 0))
    (hθ_H_pos : θ_H > 0)
    (hθ_L_pos : θ_L > 0)
    : e_H > e_L := by
  by_contra h
  push_neg at h
  rcases h.eq_or_lt with heq | hlt
  · -- Case e_H = e_L: then π'(e_H) = π'(e_L), so g_e(e_H, θ_H) = g_e(e_L, θ_L) = g_e(e_H, θ_L)
    subst heq
    have h1 : g_e e_H θ_H = g_e e_H θ_L := by linarith
    have h2 : g_e e_H θ_H < g_e e_H θ_L :=
      hg_dec_θ e_H he_H_pos (Set.mem_Ioi.mpr hθ_L_pos) (Set.mem_Ioi.mpr hθ_H_pos) hθ
    linarith
  · -- Case e_H < e_L
    have hπ : π' e_L < π' e_H :=
      hπ_dec (Set.mem_Ioi.mpr he_H_pos) (Set.mem_Ioi.mpr he_L_pos) hlt
    have hg1 : g_e e_H θ_L < g_e e_L θ_L :=
      hg_inc_e θ_L (Set.mem_Ioi.mpr he_H_pos) (Set.mem_Ioi.mpr he_L_pos) hlt
    have hg2 : g_e e_H θ_H < g_e e_H θ_L :=
      hg_dec_θ e_H he_H_pos (Set.mem_Ioi.mpr hθ_L_pos) (Set.mem_Ioi.mpr hθ_H_pos) hθ
    -- g_e(e_H, θ_H) < g_e(e_H, θ_L) < g_e(e_L, θ_L)
    -- So π'(e_H) = g_e(e_H, θ_H) < g_e(e_L, θ_L) = π'(e_L), contradicting π'(e_L) < π'(e_H)
    linarith