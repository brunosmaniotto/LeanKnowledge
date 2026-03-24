import Mathlib

open Set

/--
The image of a filter `F` on `X` under a function `f : X → Y` is a filter on `Y`.
Its sets are the subsets of `Y` whose preimages under `f` are in `F`.
This is also known as the pushforward filter.
-/
def image_filter {X Y : Type*} (f : X → Y) (F : Filter X) : Filter Y :=
  Filter.map f F