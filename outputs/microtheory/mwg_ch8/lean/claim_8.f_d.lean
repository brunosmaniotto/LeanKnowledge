import Mathlib

-- Finite game structure
variable {I : Type*} [Fintype I] [DecidableEq I]
variable {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)] [∀ i, Nonempty (S i)]

-- Mixed strategy: probability distribution over pure strategies
def MixedStrategy (S : I → Type*) [∀ i, Fintype (S i)] (i : I) := S i → ℝ

-- A mixed strategy profile