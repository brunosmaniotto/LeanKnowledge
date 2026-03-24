import Mathlib

open Metric

variable {X : Type u} [MetricSpace X]

theorem touching_centers_ne (c1 c2 : X) (r1 r2 : ℝ)
    (h_ne : sphere c1 r1 ≠ sphere c2 r2)
    (h_common : ∃ x, x ∈ sphere c1 r1 ∧ x ∈ sphere c2 r2) : c1 ≠ c2 := by
  intro h
  rcases h_common with ⟨x, hx1, hx2⟩
  have h1 : dist x c1 = r1 := hx1
  have h2 : dist x c2 = r2 := hx2
  have h_r_eq : r1 = r2 := by
    calc
      r1 = dist x c1 := Eq.symm h1
      _ = dist x c2 := by rw [h]
      _ = r2 := h2
  have h_set_eq : sphere c1 r1 = sphere c2 r2 := by
    ext y
    simp only [mem_sphere]
    rw [h, h_r_eq]
  exact h_ne h_set_eq