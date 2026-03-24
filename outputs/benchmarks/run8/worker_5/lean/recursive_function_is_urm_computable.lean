import Mathlib

/--
Every partial recursive function is computable in Mathlib's standard model.
This is a formal interpretation of "Every recursive function is URM computable",
as URM-computability is not formalized in Mathlib, but is known to be equivalent
to the class of partial recursive functions, which is represented by `Partrec`
(functions computable by Turing machines).
-/
theorem Recursive_Function_is_URM_Computable {f : ℕ →. ℕ} (h : Nat.Partrec f) : Partrec f :=
  Partrec.nat_iff.mpr h