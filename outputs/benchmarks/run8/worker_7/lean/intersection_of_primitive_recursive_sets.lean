import Mathlib

open Computability

theorem Intersection_of_Primitive_Recursive_Sets (A B : Set ℕ) [DecidablePred A] [DecidablePred B]
    (hA : PrimrecPred A) (hB : PrimrecPred B) : PrimrecPred (A ⊓ B) :=
  PrimrecPred.and hA hB