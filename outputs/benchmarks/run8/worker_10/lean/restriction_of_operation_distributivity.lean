import Mathlib

variable {S : Type*} (mul comp : S → S → S)

structure Restriction (T : Set S) where
  mul_closed : ∀ ⦃a b⦄, a ∈ T → b ∈ T → mul a b ∈ T
  comp_closed : ∀ ⦃a b⦄, a ∈ T → b ∈ T → comp a b ∈ T

def restrictMul (T : Set S) (h : Restriction mul comp T) : Subtype T → Subtype T → Subtype T :=
  fun ⟨a, ha⟩ ⟨b, hb⟩ => ⟨mul a b, h.mul_closed ha hb⟩