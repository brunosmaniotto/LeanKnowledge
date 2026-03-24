import Mathlib

/-- The short-run market period: at least one input is fixed per firm,
    and the set of potential sellers is a fixed finite subset of existing firms. -/
structure ShortRunMarket (Firm Input : Type*) where
  /-- The set of firms that already exist and are able to operate. -/
  existingFirms : Finset Firm
  /-- The set of potential sellers in the short-run market. -/
  sellers : Finset Firm
  /-- For each firm, the set of inputs that are fixed in the short run. -/
  fixedInputs : Firm → Finset Input
  /-- At least one input is fixed for every active seller. -/
  has_fixed_input : ∀ f ∈ sellers, (fixedInputs f).Nonempty
  /-- Sellers are limited to already-existing firms. -/
  sellers_sub : sellers ⊆ existingFirms