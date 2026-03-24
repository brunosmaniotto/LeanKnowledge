import Mathlib

noncomputable section

open Finset BigOperators
open Topology
open BigOperators

noncomputable def indirectUtility {n : ℕ} (u : (Fin n → ℝ) → ℝ) (p : Fin n → ℝ) (w : ℝ) : ℝ :=
  sSup {v : ℝ | ∃ x : Fin n → ℝ, (∀ i, 0 ≤ x i) ∧ ∑ i, p i * x i ≤ w ∧ v = u x}

theorem indirect_utility_hom_deg_zero {n : ℕ} (u : (Fin n → ℝ) → ℝ) (p : Fin n → ℝ) (w : ℝ)
    (t : ℝ) (ht : 0 < t) :
    indirectUtility u (fun i => t * p i) (t * w) = indirectUtility u p w := by
  unfold indirectUtility
  congr 1
  ext v
  simp only [Set.mem_setOf_eq]
  have key : ∀ x : Fin n → ℝ, ∑ i, (t * p i) * x i = t * ∑ i, p i * x i := fun x => by
    rw [Finset.mul_sum]; exact Finset.sum_congr rfl (fun i _ => by ring)
  constructor
  · rintro ⟨x, hpos, hbudget, hv⟩
    exact ⟨x, hpos, by nlinarith [key x], hv⟩
  · rintro ⟨x, hpos, hbudget, hv⟩
    exact ⟨x, hpos, by nlinarith [key x], hv⟩