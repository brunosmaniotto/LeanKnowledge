import Mathlib
open Subgroup
open Set

variable {G : Type*} [Group G] (H K : Subgroup G)

/-- Predicate for G being the internal direct product of subgroups H and K. -/
def IsInternalDirectProduct : Prop :=
  ∃ (f : (H × K) ≃* G), ∀ (h : H) (k : K), f (h, k) = (h : G) * (k : G)