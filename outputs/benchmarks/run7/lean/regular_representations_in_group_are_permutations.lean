import Mathlib

variable {G : Type} [Group G]

theorem left_regular_representation_bijective (a : G) :
    Function.Bijective (fun x : G => a * x) :=
  (Equiv.mulLeft a).bijective