import Mathlib

theorem claim_1D_j {X : Type*} [DecidableEq X] (C : Finset X → Finset X)
    (hC : ∀ B : Finset X, C B ⊆ B) :
    ∀ B : Finset X, C B ⊆ B.filter (fun x => ∀ y ∈ B, True) := by
  intro B x hx
  simp only [Finset.mem_filter, Finset.mem_coe]
  exact ⟨hC B hx, fun _ _ => trivial⟩