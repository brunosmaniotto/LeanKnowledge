import Mathlib
open Topology

variable {I : Type*} [Fintype I] [DecidableEq I] {L : ℕ}

abbrev CommodityBundle (L : ℕ) := Fin L → ℝ

theorem Proposition_17_F_5
    (pref : I → CommodityBundle L → CommodityBundle L → Prop)
    (ω x : I → CommodityBundle L)
    (h_refl : ∀ i, ∀ a : CommodityBundle L, pref i a a)
    (h_strictly_convex : ∀ i, ∀ a b : CommodityBundle L,
      pref i a b → a ≠ b →
        (pref i (fun l => (a l + b l) / 2) b ∧
         ¬ pref i b (fun l => (a l + b l) / 2)))
    (h_equil : ∀ i, pref i (x i) (ω i))
    (h_pareto_no_improve :
      ∀ (y : I → CommodityBundle L),
      (∀ i, pref i (y i) (ω i)) →
      (∀ i, pref i (ω i) (y i)))
    : ∀ i, x i = ω i := by
  by_contra h
  push_neg at h
  obtain ⟨j, hj⟩ := h
  have hsc := h_strictly_convex j (x j) (ω j) (h_equil j) hj
  let y : I → CommodityBundle L := fun i =>
    if i = j then (fun l => (x j l + ω j l) / 2) else ω i
  have hy : ∀ i, pref i (y i) (ω i) := by
    intro i
    simp only [y]
    split_ifs with heq
    · subst heq; exact hsc.1
    · exact h_refl i (ω i)
  have := h_pareto_no_improve y hy j
  simp only [y, if_pos rfl] at this
  exact hsc.2 this