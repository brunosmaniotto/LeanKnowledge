import Mathlib

theorem same_conjugate_iff_same_coset (G : Type _) [Group G] (a g h : G) :
    g * a * g⁻¹ = h * a * h⁻¹ ↔ g⁻¹ * h ∈ Subgroup.centralizer ({a} : Set G) := by
  constructor
  · intro h_eq
    rw [Subgroup.mem_centralizer_iff]
    intro x hx
    rw [Set.mem_singleton_iff] at hx
    rw [hx]
    calc
      a * (g⁻¹ * h) = (g⁻¹ * g) * a * (g⁻¹ * h) := by simp
      _ = g⁻¹ * (g * a * g⁻¹) * h := by group
      _ = g⁻¹ * (h * a * h⁻¹) * h := by rw [h_eq]
      _ = (g⁻¹ * h) * a * (h⁻¹ * h) := by group
      _ = (g⁻¹ * h) * a * 1 := by simp
      _ = (g⁻¹ * h) * a := by simp
  · intro h_mem
    have h_comm := (Subgroup.mem_centralizer_iff.mp h_mem) a (Set.mem_singleton a)
    calc
      g * a * g⁻¹ = g * a * g⁻¹ * 1 := by simp
      _ = g * a * g⁻¹ * (h * h⁻¹) := by simp
      _ = g * a * (g⁻¹ * h) * h⁻¹ := by group
      _ = g * (a * (g⁻¹ * h)) * h⁻¹ := by group
      _ = g * ((g⁻¹ * h) * a) * h⁻¹ := by rw [h_comm]
      _ = (g * g⁻¹) * h * a * h⁻¹ := by group
      _ = 1 * h * a * h⁻¹ := by simp
      _ = h * a * h⁻¹ := by simp