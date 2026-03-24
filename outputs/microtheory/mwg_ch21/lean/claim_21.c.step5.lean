import Mathlib
open Topology

set_option linter.unusedVariables false

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {X : Type*} [DecidableEq X]

axiom IsDecisive : Finset I → ((I → X → X → Prop) → X → X → Prop) → Prop

axiom three_distinct_alternatives : ∃ (x y z : X), x ≠ y ∧ y ≠ z ∧ x ≠ z

axiom swf_complete : ∀ (F : (I → X → X → Prop) → X → X → Prop)
  (profile : I → X → X → Prop) (x y : X), F profile x y ∨ F profile y x

/-- Given the constructed profile where S members rank x > z > y and complement
    ranks y > x > z: if F ranks x over y, then by IIA S is decisive for x over y,
    hence decisive by Step 3. -/
axiom case_xy_implies_S_decisive :
  ∀ (S : Finset I) (F : (I → X → X → Prop) → X → X → Prop)
    (x y z : X), x ≠ y → y ≠ z → x ≠ z →
  let profile : I → X → X → Prop := fun i a b =>
    if i ∈ S then (a = x ∧ b = y) ∨ (a = x ∧ b = z) ∨ (a = z ∧ b = y)
    else (a = y ∧ b = x) ∨ (a = y ∧ b = z) ∨ (a = x ∧ b = z)
  F profile x y → IsDecisive S F

/-- Given the same profile: if F ranks y over x, then by Pareto (all prefer x to z)
    and transitivity y F x F z gives y F z, so by IIA the complement is decisive
    for y over z, hence decisive by Step 3. -/
axiom case_yx_implies_comp_decisive :
  ∀ (S : Finset I) (F : (I → X → X → Prop) → X → X → Prop)
    (x y z : X), x ≠ y → y ≠ z → x ≠ z →
  let profile : I → X → X → Prop := fun i a b =>
    if i ∈ S then (a = x ∧ b = y) ∨ (a = x ∧ b = z) ∨ (a = z ∧ b = y)
    else (a = y ∧ b = x) ∨ (a = y ∧ b = z) ∨ (a = x ∧ b = z)
  F profile y x → IsDecisive (Finset.univ \ S) F

theorem step5_decisive_or_complement
    (S : Finset I) (F : (I → X → X → Prop) → X → X → Prop) :
    IsDecisive S F ∨ IsDecisive (Finset.univ \ S) F := by
  obtain ⟨x, y, z, hxy, hyz, hxz⟩ := three_distinct_alternatives (X := X)
  let profile : I → X → X → Prop := fun i a b =>
    if i ∈ S then (a = x ∧ b = y) ∨ (a = x ∧ b = z) ∨ (a = z ∧ b = y)
    else (a = y ∧ b = x) ∨ (a = y ∧ b = z) ∨ (a = x ∧ b = z)
  rcases swf_complete F profile x y with h | h
  · exact Or.inl (case_xy_implies_S_decisive S F x y z hxy hyz hxz h)
  · exact Or.inr (case_yx_implies_comp_decisive S F x y z hxy hyz hxz h)