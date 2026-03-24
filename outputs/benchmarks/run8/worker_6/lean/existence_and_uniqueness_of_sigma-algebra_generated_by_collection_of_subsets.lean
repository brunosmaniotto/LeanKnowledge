import Mathlib

open MeasurableSpace

theorem exists_unique_sigma_algebra_generated_by (α : Type u) (G : Set (Set α)) :
    ∃! (m : MeasurableSpace α), (∀ s ∈ G, @MeasurableSet α m s) ∧
      ∀ (m' : MeasurableSpace α), (∀ s ∈ G, @MeasurableSet α m' s) → m ≤ m' := by
  set m0 := generateFrom G
  refine ⟨m0, ⟨fun s hs => measurableSet_generateFrom hs, fun m' h => generateFrom_le h⟩, ?_⟩
  intro m ⟨hG, hmin⟩
  have h1 : m0 ≤ m := generateFrom_le hG
  have h2 : m ≤ m0 := hmin m0 (fun s hs => measurableSet_generateFrom hs)
  exact le_antisymm h2 h1