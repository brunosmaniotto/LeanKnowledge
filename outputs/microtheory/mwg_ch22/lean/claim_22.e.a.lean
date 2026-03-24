import Mathlib

theorem claim_22_E_a {α : Type*} {W : α → ℝ} {U U' : Set α} {x : α}
    (hU'U : U' ⊆ U)
    (hxU' : x ∈ U')
    (hmax : x ∈ U ∧ ∀ y ∈ U, W y ≤ W x) :
    x ∈ U' ∧ ∀ y ∈ U', W y ≤ W x := by
  exact ⟨hxU', fun y hy => hmax.2 y (hU'U hy)⟩