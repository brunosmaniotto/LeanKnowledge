import Mathlib

theorem Supremum_of_Subset {U : Type _} [Preorder U] {S T : Set U} {a b : U}
    (hST : T ⊆ S) (hS : IsLUB S a) (hT : IsLUB T b) : b ≤ a := by
  -- `a` is an upper bound for `T` because it's an upper bound for `S` and `T ⊆ S`
  have ha_upper_T : a ∈ upperBounds T := by
    intro x hx
    have hxS : x ∈ S := hST hx
    exact hS.left hxS
  -- Since `b` is the least upper bound for `T`, it must be ≤ any upper bound (including `a`)
  exact hT.right ha_upper_T