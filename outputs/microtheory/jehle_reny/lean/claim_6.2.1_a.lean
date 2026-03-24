import Mathlib

/-- On a finite set, every rational preference has a continuous utility representation
    under the discrete topology, so continuity places no restriction. -/
theorem claim_6_2_1_a
    {X : Type*} [Fintype X] [DecidableEq X]
    (R : X → X → Prop) [DecidableRel R]
    (htotal : ∀ x y, R x y ∨ R y x)
    (htrans : ∀ x y z, R x y → R y z → R x z) :
    ∃ u : X → ℝ, (∀ x y, R x y ↔ u y ≤ u x) ∧
      @Continuous X ℝ ⊥ inferInstance u := by
  refine ⟨fun x => ((Finset.univ.filter (R x)).card : ℝ), fun x y => ?_, continuous_bot⟩
  simp only [Nat.cast_le]
  constructor
  · intro hxy
    exact Finset.card_le_card fun z hz => by
      simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hz ⊢
      exact htrans _ _ _ hxy hz
  · intro hle; by_contra hne
    have hyx := (htotal x y).resolve_left hne
    have hsub : Finset.univ.filter (R x) ⊆ Finset.univ.filter (R y) :=
      fun z hz => by
        simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hz ⊢
        exact htrans _ _ _ hyx hz
    have heq := Finset.eq_of_subset_of_card_le hsub hle
    have : y ∈ Finset.univ.filter (R x) := by
      rw [heq]; simp [Finset.mem_filter, (htotal y y).elim id id]
    simp only [Finset.mem_filter, Finset.mem_univ, true_and] at this
    exact hne this