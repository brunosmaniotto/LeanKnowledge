import Mathlib

open Finset BigOperators Topology
open BigOperators

theorem Claim_5_3_3_c
    {L : ℕ} (hL : 0 < L)
    (α : Fin L → ℝ) (hα : ∀ i, 0 < α i)
    (p : Fin L → ℝ) (hp : ∀ i, 0 < p i)
    (w : ℝ) (hw : 0 < w)
    (x : Fin L → ℝ)
    (hx : ∀ i, x i = (α i / ∑ j ∈ Finset.univ, α j) * (w / p i))
    : ∑ i ∈ Finset.univ, p i * x i = w := by
  haveI : Nonempty (Fin L) := ⟨⟨0, hL⟩⟩
  simp_rw [hx]
  have hsum_pos : 0 < ∑ j ∈ Finset.univ, α j := by
    apply Finset.sum_pos
    · intro i _; exact hα i
    · exact Finset.univ_nonempty
  have hsum_ne : (∑ j ∈ Finset.univ, α j) ≠ 0 := ne_of_gt hsum_pos
  conv_lhs =>
    arg 2; ext i
    rw [mul_comm (p i), mul_assoc, div_mul_cancel₀ w (ne_of_gt (hp i))]
  simp_rw [div_mul_eq_mul_div]
  rw [← Finset.sum_div]
  rw [div_eq_iff hsum_ne]
  rw [← Finset.sum_mul]
  ring