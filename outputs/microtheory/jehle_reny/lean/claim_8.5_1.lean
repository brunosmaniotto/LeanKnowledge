import Mathlib

open Set

theorem Claim_8_5_1
    {u_h : ℝ × ℝ → ℝ}
    {ψ_star_h : ℝ × ℝ}
    {L π_bar_L : ℝ}
    (h_cont : Continuous u_h)
    (h_no_dev : ∀ ε : ℝ, ε > 0 → u_h ψ_star_h ≥ u_h (L, π_bar_L + ε)) :
    u_h ψ_star_h ≥ u_h (L, π_bar_L) := by
  by_contra hlt
  push_neg at hlt
  have hg_cont : Continuous (fun ε : ℝ => u_h (L, π_bar_L + ε)) :=
    h_cont.comp (by fun_prop)
  have hopen : IsOpen ((fun ε : ℝ => u_h (L, π_bar_L + ε)) ⁻¹' Ioi (u_h ψ_star_h)) :=
    isOpen_Ioi.preimage hg_cont
  have hmem : (0 : ℝ) ∈ (fun ε : ℝ => u_h (L, π_bar_L + ε)) ⁻¹' Ioi (u_h ψ_star_h) := by
    simp only [mem_preimage, mem_Ioi, add_zero]; exact hlt
  obtain ⟨δ, hδ_pos, hδ_sub⟩ := Metric.isOpen_iff.mp hopen 0 hmem
  have hε : δ / 2 > 0 := by linarith
  have hball : δ / 2 ∈ Metric.ball (0 : ℝ) δ := by
    simp only [Metric.mem_ball, Real.dist_eq, sub_zero, abs_of_pos hε]; linarith
  have h1 : u_h ψ_star_h < u_h (L, π_bar_L + δ / 2) := by
    have := hδ_sub hball
    simp only [mem_preimage, mem_Ioi] at this; exact this
  linarith [h_no_dev (δ / 2) hε]