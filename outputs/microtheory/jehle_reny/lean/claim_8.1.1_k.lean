import Mathlib
open Set Topology
open Topology

theorem Claim_8_1_1_k : ∃ (g : ℝ → ℝ),
    (∃ c : ℝ, (∀ x, x < c → g x = 0) ∧ (∀ x, c ≤ x → g x = 1)) ∧
    ¬Continuous g := by
  refine ⟨fun x => if x < 1 then (0 : ℝ) else 1,
    ⟨1, fun x hx => if_pos hx, fun x hx => if_neg (not_lt.mpr hx)⟩, ?_⟩
  intro hcont
  have hpre : (fun x : ℝ => if x < 1 then (0 : ℝ) else 1) ⁻¹' (Ioi (1 / 2 : ℝ)) = Ici 1 := by
    ext x; simp only [mem_preimage, mem_Ioi, mem_Ici]
    constructor
    · intro h; by_contra hlt; push_neg at hlt; rw [if_pos hlt] at h; linarith
    · intro h; rw [if_neg (not_lt.mpr h)]; norm_num
  have hopen := hcont.isOpen_preimage (Ioi (1 / 2 : ℝ)) isOpen_Ioi
  rw [hpre] at hopen
  rw [Metric.isOpen_iff] at hopen
  obtain ⟨ε, hε, hball⟩ := hopen 1 (mem_Ici.mpr le_rfl)
  have hmem : 1 - ε / 2 ∈ Metric.ball (1 : ℝ) ε := by
    rw [Metric.mem_ball, Real.dist_eq]
    rw [show (1 - ε / 2 : ℝ) - 1 = -(ε / 2) from by ring]
    rw [abs_neg, abs_of_pos (half_pos hε)]
    linarith
  have := hball hmem
  rw [mem_Ici] at this
  linarith