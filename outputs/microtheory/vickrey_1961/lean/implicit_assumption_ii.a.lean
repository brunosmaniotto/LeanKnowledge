import Mathlib

/-- Auction price space with continuous price variation and no minimum bid increment.
    `DenselyOrdered` formalizes the absence of a minimum increment: between any two
    distinct prices there exists another. -/
structure ContinuousPriceSpace where
  /-- The type of prices in the auction -/
  Price : Type*
  /-- Prices admit a linear ordering -/
  [linearOrder : LinearOrder Price]
  /-- No minimum increment: between any two distinct prices lies another -/
  [denselyOrdered : DenselyOrdered Price]

attribute [instance] ContinuousPriceSpace.linearOrder ContinuousPriceSpace.denselyOrdered