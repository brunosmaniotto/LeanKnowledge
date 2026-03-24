import Mathlib

variable {G : Type _} [Group G]
variable (H1 H2 : Subgroup G)

/-- The multiplication map from the direct product of two subgroups to the ambient group. -/
def φ : H1 × H2 → G := λ p => (p.1 : G) * (p.2 : G)