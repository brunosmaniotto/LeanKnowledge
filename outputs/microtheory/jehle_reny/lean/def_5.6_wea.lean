import Mathlib

open BigOperators Finset
open Topology

noncomputable section

/-- The Walrasian Equilibrium Allocation (WEA). Given individual demand functions
    `xd i p w` (consumer i's demand at prices p and wealth w), endowments `ω`,
    and equilibrium prices `p`, the WEA is the allocation where each consumer i
    receives `xd i p (p · ω i)`. -/
def walrasianEquilibriumAllocation
    {I : Type*} [Fintype I]
    {n : Type*} [Fintype n]
    (xd : I → (n → ℝ) → ℝ → (n → ℝ))
    (ω : I → (n → ℝ))
    (p : n → ℝ) : I → (n → ℝ) :=
  fun i => xd i p (∑ l, p l * ω i l)

end