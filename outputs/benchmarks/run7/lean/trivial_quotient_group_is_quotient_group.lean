import Mathlib

noncomputable def trivialQuotientIso (G : Type _) [Group G] : G ⧸ (⊥ : Subgroup G) ≃* G :=
  QuotientGroup.quotientBot