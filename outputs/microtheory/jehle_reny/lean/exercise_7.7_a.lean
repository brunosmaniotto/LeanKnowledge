import Mathlib

open Finset
open Topology

/-- Von Neumann's Minimax Theorem: given a saddle point (x*, y*),
    max_x min_y u(x,y) = u(x*,y*) = min_y max_x u(x,y). -/
theorem Exercise_7_7_a
    {X Y : Type*} [Fintype X] [Nonempty X] [Fintype Y] [Nonempty Y]
    (u : X → Y → ℝ)
    (x_star : X) (y_star : Y)
    (h_max : ∀ x, u x y_star ≤ u x_star y_star)
    (h_min : ∀ y, u x_star y_star ≤ u x_star y) :
    (univ.sup' univ_nonempty fun x => univ.inf' univ_nonempty fun y => u x y) =
      u x_star y_star ∧
    u x_star y_star =
      (univ.inf' univ_nonempty fun y => univ.sup' univ_nonempty fun x => u x y) := by
  constructor <;> apply le_antisymm
  · -- sup inf ≤ v
    rw [sup'_le_iff]
    intro x _
    exact (inf'_le _ (mem_univ y_star)).trans (h_max x)
  · -- v ≤ sup inf
    have h1 : u x_star y_star ≤ univ.inf' univ_nonempty (u x_star) := by
      rw [le_inf'_iff]; intro y _; exact h_min y
    exact h1.trans (le_sup' (fun x => univ.inf' univ_nonempty (u x)) (mem_univ x_star))
  · -- v ≤ inf sup
    rw [le_inf'_iff]
    intro y _
    exact (h_min y).trans (le_sup' (fun x => u x y) (mem_univ x_star))
  · -- inf sup ≤ v
    have h2 : univ.sup' univ_nonempty (fun x => u x y_star) ≤ u x_star y_star := by
      rw [sup'_le_iff]; intro x _; exact h_max x
    exact (inf'_le _ (mem_univ y_star)).trans h2