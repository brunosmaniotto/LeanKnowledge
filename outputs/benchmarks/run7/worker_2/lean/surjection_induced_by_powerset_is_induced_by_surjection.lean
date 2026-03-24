import Mathlib

theorem surjective_direct_image_imp_restriction_surjective {S T : Type} (R : Set (S × T))
    (h_surj : Function.Surjective fun (A : Set S) => { y | ∃ x ∈ A, (x, y) ∈ R }) :
    ∀ y : T, ∃ x ∈ { x | ∃ t : T, (x, t) ∈ R }, (x, y) ∈ R := by
  intro y
  -- Get a preimage of {y} under the direct image map
  rcases h_surj {y} with ⟨A, hA⟩
  -- Since y ∈ {y}, we have y ∈ directImage R A
  have h1 : y ∈ (fun (A : Set S) => { y | ∃ x ∈ A, (x, y) ∈ R }) A := by
    rw [hA]
    exact Set.mem_singleton y
  -- Simplify h1 to get ∃ x ∈ A, (x, y) ∈ R
  have h2 : ∃ x ∈ A, (x, y) ∈ R := by
    simpa [Set.mem_setOf_eq] using h1
  -- Extract such x
  rcases h2 with ⟨x, hxA, hxy⟩
  -- x is in X because (x, y) ∈ R
  have hxX : x ∈ { x | ∃ t : T, (x, t) ∈ R } := ⟨y, hxy⟩
  exact ⟨x, hxX, hxy⟩