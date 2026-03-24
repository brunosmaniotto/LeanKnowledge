import Mathlib
open Topology

theorem deadweight_loss_nonneg
    {a b : ℝ} (hab : a ≤ b)
    (h : ℝ → ℝ) (h_mono : AntitoneOn h (Set.Icc a b))
    (h_cont : ContinuousOn h (Set.Icc a b)) :
    0 ≤ ∫ s in a..b, (h s - h b) := by
  apply intervalIntegral.integral_nonneg hab
  intro x ⟨hax, hxb⟩
  simp only [sub_nonneg]
  exact h_mono (Set.mem_Icc.mpr ⟨hax, hxb⟩) (Set.right_mem_Icc.mpr hab) hxb