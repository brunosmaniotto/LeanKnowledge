import Mathlib

variable {m n : Type*} [Group G]

/- The matrix type `Matrix m n G` is defined as `m → n → G`.
   Since `G` is a group, the pointwise operations make `m → n → G` a group.
   The existing `Pi.group` instance provides exactly the Hadamard product structure. -/