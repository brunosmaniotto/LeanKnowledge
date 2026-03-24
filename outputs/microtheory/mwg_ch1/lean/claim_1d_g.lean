import Mathlib
open Topology

/-- There may be more than one rational preference relation that rationalizes
    a given choice structure. We use X = Bool, B = {true}, C(B) = {true}.
    R₁ = always True, R₂ = (fun x y => x = y ∨ x = true). Both are rational
    and both rationalize C on B, but they differ (R₁ false true = True, while
    R₂ false true requires false = true ∨ false = true, which is False). -/
theorem claim_1D_g :
    ∃ (X : Type) (B : Finset X) (C : Finset X → Finset X)
      (R₁ R₂ : X → X → Prop),
      -- Both R₁ and R₂ are rational (complete and transitive)
      (∀ x y : X, R₁ x y ∨ R₁ y x) ∧
      (∀ x y z : X, R₁ x y → R₁ y z → R₁ x z) ∧
      (∀ x y : X, R₂ x y ∨ R₂ y x) ∧
      (∀ x y z : X, R₂ x y → R₂ y z → R₂ x z) ∧
      -- Both rationalize C on B: C(B) = {x ∈ B | ∀ y ∈ B, R x y}
      (∀ x, x ∈ C B ↔ x ∈ B ∧ ∀ y, y ∈ B → R₁ x y) ∧
      (∀ x, x ∈ C B ↔ x ∈ B ∧ ∀ y, y ∈ B → R₂ x y) ∧
      -- Yet R₁ ≠ R₂
      R₁ ≠ R₂ := by
  -- X = Bool, B = {true} (singleton), C always returns B
  refine ⟨Bool, {true}, fun _ => {true},
    fun _ _ => True,                       -- R₁: universal indifference
    fun x y => x = y ∨ x = true,          -- R₂: true preferred to all, false only to itself
    ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  -- R₁ complete
  · intro x y; left; trivial
  -- R₁ transitive
  · intro x y z _ _; trivial
  -- R₂ complete
  · intro x y; cases x <;> cases y <;> simp
  -- R₂ transitive
  · intro x y z hxy hyz
    cases x <;> cases y <;> cases z <;> simp_all
  -- R₁ rationalizes C on B
  · intro x; simp
  -- R₂ rationalizes C on B
  · intro x
    simp only [Finset.mem_singleton]
    constructor
    · intro h; exact ⟨h, fun y hy => by subst h; subst hy; left; rfl⟩
    · intro ⟨h, _⟩; exact h
  -- R₁ ≠ R₂
  · intro h
    have : (fun _ _ => True : Bool → Bool → Prop) false true =
           (fun x y => x = y ∨ x = true : Bool → Bool → Prop) false true := by
      rw [h]
    simp at this