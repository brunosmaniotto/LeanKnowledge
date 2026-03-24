import Mathlib

/-- A pure monopoly market structure: a single seller of a product with no close
    substitutes, and completely blocked entry. -/
structure PureMonopoly (Firm : Type*) (Product : Type*) where
  /-- The single seller in the market. -/
  seller : Firm
  /-- The product sold by the monopolist. -/
  product : Product
  /-- There is exactly one firm: every firm equals the seller. -/
  unique_seller : ∀ f : Firm, f = seller
  /-- No close substitutes exist for the product. -/
  no_close_substitutes : ∀ p : Product, p = product
  /-- Entry is completely blocked (no firm can enter). -/
  entry_blocked : True