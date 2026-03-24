import Mathlib

open Set

namespace Subgroup

variable {G : Type _} [Group G] (H : Subgroup G)

theorem mul_self_eq : Set.image2 (· * ·) (H : Set G) (H : Set G) = H := by
  ext x
  constructor
  · intro hx
    rcases hx with ⟨a, ha, b, hb, rfl⟩
    exact H.mul_mem ha hb
  · intro hx
    exact ⟨x, hx, 1, H.one_mem, mul_one x⟩

end Subgroup