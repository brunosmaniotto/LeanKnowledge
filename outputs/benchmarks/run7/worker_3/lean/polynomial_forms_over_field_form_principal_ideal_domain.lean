import Mathlib

theorem Polynomial_Forms_over_Field_form_Principal_Ideal_Domain (F : Type _) [Field F] :
    IsPrincipalIdealRing (Polynomial F) := by
  infer_instance