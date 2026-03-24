import Mathlib

-- A subgroup of index 2 is proper (i.e., not the whole group).
lemma subgroup_of_index_two_is_proper {G : Type*} [Group G] {H : Subgroup G} (h_index : H.index = 2) : H ≠ ⊤ := by
  -- We prove H ≠ ⊤ by showing that their indices are different.
  -- The general lemma is `ne_of_apply_ne f`, which proves `x ≠ y` from `f x ≠ f y`.
  apply ne_of_apply_ne Subgroup.index
  -- By hypothesis, `H.index = 2`.
  -- By the lemma `Subgroup.index_top`, `(⊤ : Subgroup G).index = 1`.
  rw [h_index, Subgroup.index_top]
  -- The goal becomes `2 ≠ 1`, which is true by calculation.
  norm_num

-- If the normalizer of a set has index 2, it cannot be the trivial subgroup.