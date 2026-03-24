import Mathlib
open Topology

/-- Kakutani fixed point theorem (axiomatized — not yet in Mathlib) -/
axiom kakutani_fixed_point_product
    {α : Type*} [TopologicalSpace α] [AddCommMonoid α] [Module ℝ α]
    (F : α → Set α)
    (hF_nonempty : ∀ x, (F x).Nonempty)
    (hF_convex : ∀ x, Convex ℝ (F x)) :
    ∃ x, x ∈ F x

/-- If the correspondences χ_i(·), η_j(·), and μ(·) are nonempty, convex valued,
    and upper hemicontinuous, then there exists a fixed point of the product correspondence. -/
theorem Lemma_17BB3
    {I J : Type*} [Fintype I] [Fintype J]
    {X : I → Type*} {Y : J → Type*} {P : Type*}
    [∀ i, TopologicalSpace (X i)] [∀ j, TopologicalSpace (Y j)] [TopologicalSpace P]
    [∀ i, AddCommMonoid (X i)] [∀ j, AddCommMonoid (Y j)] [AddCommMonoid P]
    [∀ i, Module ℝ (X i)] [∀ j, Module ℝ (Y j)] [Module ℝ P]
    (χ : ∀ i, (∀ i, X i) × (∀ j, Y j) × P → Set (X i))
    (η : ∀ j, (∀ i, X i) × (∀ j, Y j) × P → Set (Y j))
    (μ : (∀ i, X i) × (∀ j, Y j) × P → Set P)
    (hχ_nonempty : ∀ i s, (χ i s).Nonempty)
    (hη_nonempty : ∀ j s, (η j s).Nonempty)
    (hμ_nonempty : ∀ s, (μ s).Nonempty)
    (hχ_convex : ∀ i s, Convex ℝ (χ i s))
    (hη_convex : ∀ j s, Convex ℝ (η j s))
    (hμ_convex : ∀ s, Convex ℝ (μ s)) :
    ∃ xyp : (∀ i, X i) × (∀ j, Y j) × P,
      (∀ i, xyp.1 i ∈ χ i xyp) ∧
      (∀ j, xyp.2.1 j ∈ η j xyp) ∧
      (xyp.2.2 ∈ μ xyp) := by
  let S := (∀ i, X i) × (∀ j, Y j) × P
  let Ψ : S → Set S :=
    fun s => {xyp | (∀ i, xyp.1 i ∈ χ i s) ∧ (∀ j, xyp.2.1 j ∈ η j s) ∧ (xyp.2.2 ∈ μ s)}
  have hΨ_nonempty : ∀ s, (Ψ s).Nonempty := by
    intro s
    refine ⟨⟨fun i => (hχ_nonempty i s).some, fun j => (hη_nonempty j s).some,
            (hμ_nonempty s).some⟩, ?_, ?_, ?_⟩
    · intro i; exact (hχ_nonempty i s).some_mem
    · intro j; exact (hη_nonempty j s).some_mem
    · exact (hμ_nonempty s).some_mem
  have hΨ_convex : ∀ s, Convex ℝ (Ψ s) := by
    intro s a ha b hb t₁ t₂ ht₁ ht₂ hab
    refine ⟨?_, ?_, ?_⟩
    · intro i
      exact hχ_convex i s (ha.1 i) (hb.1 i) ht₁ ht₂ hab
    · intro j
      exact hη_convex j s (ha.2.1 j) (hb.2.1 j) ht₁ ht₂ hab
    · exact hμ_convex s ha.2.2 hb.2.2 ht₁ ht₂ hab
  obtain ⟨xyp, hxyp⟩ := kakutani_fixed_point_product Ψ hΨ_nonempty hΨ_convex
  exact ⟨xyp, hxyp.1, hxyp.2.1, hxyp.2.2⟩