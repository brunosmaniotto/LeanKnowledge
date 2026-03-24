import Mathlib

theorem centers_ne_of_spheres_ne_and_intersect {α : Type*} [MetricSpace α] {c1 c2 : α} {r1 r2 : ℝ} {B : α}
    (hB1 : B ∈ Metric.sphere c1 r1) (hB2 : B ∈ Metric.sphere c2 r2) (h_ne : Metric.sphere c1 r1 ≠ Metric.sphere c2 r2) :
    c1 ≠ c2 := by
  intro h_eq
  have h1 : dist B c1 = r1 := hB1
  have h2 : dist B c2 = r2 := hB2
  rw [h_eq] at h1
  have h_radii : r1 = r2 := by linarith
  have h_sphere_eq : Metric.sphere c1 r1 = Metric.sphere c2 r2 := by rw [h_eq, h_radii]
  exact h_ne h_sphere_eq