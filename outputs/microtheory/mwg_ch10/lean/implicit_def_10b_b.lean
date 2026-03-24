import Mathlib

/-- A price vector in a competitive economy with `L` goods.
    Each component `p i` is the market price of good `i`.
    The price-taking assumption (Def 10B.b) is enforced structurally:
    agents receive a `PriceVector` as a fixed parameter. -/
abbrev PriceVector (L : ℕ) := Fin L → ℝ