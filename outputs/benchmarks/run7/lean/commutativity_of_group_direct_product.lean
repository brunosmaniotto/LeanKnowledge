import Mathlib

def direct_product_comm {G H : Type*} [Group G] [Group H] : G × H ≃* H × G :=
  MulEquiv.prodComm