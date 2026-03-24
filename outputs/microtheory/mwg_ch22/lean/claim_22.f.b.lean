import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem marginal_contributions_sum_to_grand_coalition
    (n : ℕ) (v : Finset (Fin n) → ℝ) (hv : v ∅ = 0) (π : Equiv.Perm (Fin n)) :
    ∑ i ∈ Finset.range n,
      (v (Finset.image π (Finset.univ.filter (fun j : Fin n => j.val < i + 1))) -
       v (Finset.image π (Finset.univ.filter (fun j : Fin n => j.val < i)))) =
    v Finset.univ := by
  let f : ℕ → ℝ := fun i => v (Finset.image π (Finset.univ.filter (fun j : Fin n => j.val < i)))
  have h1 : ∀ i ∈ Finset.range n,
      v (Finset.image π (Finset.univ.filter (fun j : Fin n => j.val < i + 1))) -
      v (Finset.image π (Finset.univ.filter (fun j : Fin n => j.val < i))) =
      f (i + 1) - f i := by
    intros i _
    rfl
  rw [Finset.sum_congr rfl h1]
  rw [Finset.sum_range_sub f]
  show f n - f 0 = v Finset.univ
  have h0 : f 0 = 0 := by
    show v (Finset.image π (Finset.univ.filter (fun j : Fin n => j.val < 0))) = 0
    simp [hv]
  have hn : f n = v Finset.univ := by
    show v (Finset.image π (Finset.univ.filter (fun j : Fin n => j.val < n))) = v Finset.univ
    congr 1
    have hfilt : Finset.univ.filter (fun j : Fin n => j.val < n) = Finset.univ := by
      ext x; simp
    rw [hfilt]
    ext x; simp
  linarith