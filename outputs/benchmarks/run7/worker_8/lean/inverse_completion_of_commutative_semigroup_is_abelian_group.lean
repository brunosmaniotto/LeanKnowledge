import Mathlib

variable (S : Type u) [CommSemigroup S] [IsCancelMul S]

noncomputable def InverseCompletion : Type u :=
  Localization (⊤ : Submonoid (WithOne S))

noncomputable instance : CommGroup (InverseCompletion S) := by
  unfold InverseCompletion
  infer_instance