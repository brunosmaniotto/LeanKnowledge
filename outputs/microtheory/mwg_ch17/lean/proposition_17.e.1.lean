import Mathlib
open BigOperators Finset

theorem Proposition_17_E_1
    (L I : ℕ) (hIL : I < L)
    (p : Fin L → ℝ) (hp : p ≠ 0)
    (z : Fin I → Fin L → ℝ)
    (S : Fin I → Fin L → Fin L → ℝ)
    (Dz : Fin L → Fin L → ℝ)
    (hDz : ∀ a b : Fin L, Dz a b = ∑ i : Fin I, S i a b)
    (hS_neg : ∀ i : Fin I, ∀ v : Fin L → ℝ,
      v ≠ 0 → ∑ l, p l * v l = 0 → ∑ l, z i l * v l = 0 →
      ∑ a, ∑ b, v a * S i a b * v b < 0)
    (dp : Fin L → ℝ) (hdp_ne : dp ≠ 0)
    (hdp_p : ∑ l, p l * dp l = 0)
    (hdp_z : ∀ i : Fin I, ∑ l, z i l * dp l = 0)
    (hI_pos : 0 < I) :
    ∑ a : Fin L, ∑ b : Fin L, dp a * Dz a b * dp b < 0 := by
  have key : ∑ a : Fin L, ∑ b : Fin L, dp a * Dz a b * dp b =
      ∑ i : Fin I, (∑ a : Fin L, ∑ b : Fin L, dp a * S i a b * dp b) := by
    simp_rw [hDz, Finset.mul_sum, Finset.sum_mul]
    trans ∑ a : Fin L, ∑ i : Fin I, ∑ b : Fin L, (dp a * S i a b) * dp b
    · exact sum_congr rfl fun a _ => sum_comm
    · exact sum_comm
  rw [key]
  have i₀ : Fin I := ⟨0, hI_pos⟩
  calc ∑ i : Fin I, (∑ a, ∑ b, dp a * S i a b * dp b)
      < ∑ _i : Fin I, (0 : ℝ) :=
        sum_lt_sum (fun i _ => le_of_lt (hS_neg i dp hdp_ne hdp_p (hdp_z i)))
          ⟨i₀, mem_univ _, hS_neg i₀ dp hdp_ne hdp_p (hdp_z i₀)⟩
    _ = 0 := sum_const_zero