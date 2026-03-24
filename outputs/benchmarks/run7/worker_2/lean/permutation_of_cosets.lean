import Mathlib

open Subgroup
open QuotientGroup

variable {G : Type _} [Group G] (H : Subgroup G)

local notation "S" => G ⧸ H

/-- The homomorphism from G to the permutation group of left cosets of H. -/
def θ : G →* Equiv.Perm S := MulAction.toPermHom G S