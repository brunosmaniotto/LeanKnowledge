import Mathlib

open QuotientGroup

variable {G : Type*} [Group G]

theorem preimage_normal_of_normal_quotient (H : Subgroup G) [H.Normal]
    (K : Subgroup (G ⧸ H)) [K.Normal] : (K.comap (mk' H)).Normal := by
  infer_instance