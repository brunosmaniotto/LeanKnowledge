import Mathlib

open Finset Set Function
open Topology

variable {I : Type} [Fintype I] [Inhabited I] [DecidableEq I]
variable (v : I → ℝ) (hv_nonneg : ∀ i, v i ≥ 0)

/-
An allocation specifies which bidder (if any) receives the single item.
`some i` means bidder `i` gets the item.
`none` means no one gets the item.
-/
def Allocation := Option I

/-
The utility for a bidder `j` given an allocation `alloc`.
If `j` receives the item, their utility is their valuation `v j`. Otherwise, it's 0.
-/