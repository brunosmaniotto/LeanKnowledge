import Mathlib
open BigOperators
open Topology

theorem walrasian_equilibrium_iff_reduced_excess_demand_zero
    {L : ℕ} (hL : 0 < L)
    (z : Fin L → ℝ)
    (p : Fin L → ℝ)
    (hp_pos : ∀ i, 0 < p i)
    (walras_law : ∑ i : Fin L, p i * z i = 0) :
    (∀ i, z i = 0) ↔ (∀ i : Fin L, (i : ℕ) < L - 1 → z i = 0) := by
  constructor
  · intro h i _
    exact h i
  · intro h_reduced i
    by_cases hi : (i : ℕ) < L - 1
    · exact h_reduced i hi
    · have hiL : (i : ℕ) = L - 1 := by omega
      have hsum_rest : ∑ j ∈ Finset.univ.erase i, p j * z j = 0 := by
        apply Finset.sum_eq_zero
        intro j hj
        have hji : j ≠ i := Finset.ne_of_mem_erase hj
        have hjL : (j : ℕ) < L - 1 := by
          have := j.isLt
          have := Fin.val_ne_of_ne hji
          omega
        simp [h_reduced j hjL]
      have hdecomp : ∑ j : Fin L, p j * z j =
          p i * z i + ∑ j ∈ Finset.univ.erase i, p j * z j := by
        rw [← Finset.add_sum_erase _ _ (Finset.mem_univ i)]
      have hpz : p i * z i = 0 := by linarith
      rcases mul_eq_zero.mp hpz with hp0 | hz0
      · linarith [hp_pos i]
      · exact hz0