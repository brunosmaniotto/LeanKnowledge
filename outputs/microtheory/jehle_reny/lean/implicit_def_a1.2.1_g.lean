import Mathlib

open Set

namespace MWG

/-- MWG Definition A1.2.1(g): The union S ∪ T ≡ {x | x ∈ S or x ∈ T} -/
abbrev setUnion {α : Type*} (S T : Set α) : Set α := S ∪ T

/-- MWG Definition A1.2.1(g): The intersection S ∩ T ≡ {x | x ∈ S and x ∈ T} -/
abbrev setInter {α : Type*} (S T : Set α) : Set α := S ∩ T

end MWG