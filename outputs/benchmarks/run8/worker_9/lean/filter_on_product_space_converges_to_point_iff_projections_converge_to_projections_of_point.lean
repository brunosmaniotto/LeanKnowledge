import Mathlib

open Filter Topology

theorem Filter_on_Product_Space_Converges_to_Point_iff_Projections_Converge_to_Projections_of_Point
    {I : Type*} {X : I → Type*} [∀ i, TopologicalSpace (X i)]
    (F : Filter (∀ i, X i)) (x : ∀ i, X i) :
    F ≤ 𝓝 x ↔ ∀ i, Tendsto (fun a ↦ a i) F (𝓝 (x i)) := by
  rw [← tendsto_id', tendsto_pi_nhds]
  simp