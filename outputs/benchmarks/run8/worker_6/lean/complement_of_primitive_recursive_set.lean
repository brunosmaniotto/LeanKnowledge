import Mathlib

open Set

/--
If a set `S ⊆ ℕ` is primitive recursive, then its complement `Sᶜ` is also
primitive recursive.
-/
theorem Complement_of_Primitive_Recursive_Set {S : Set ℕ} [DecidablePred S]
    (hS : PrimrecPred S) : PrimrecPred Sᶜ :=
  hS.not