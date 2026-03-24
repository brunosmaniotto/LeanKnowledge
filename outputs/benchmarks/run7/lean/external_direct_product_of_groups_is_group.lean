import Mathlib

-- The group instance for the product is already defined in Mathlib
-- We prove that the identity element is (1,1)
theorem external_direct_product_identity (G₁ G₂ : Type*) [Group G₁] [Group G₂] : 
    (1 : G₁ × G₂) = (1, 1) :=
  rfl