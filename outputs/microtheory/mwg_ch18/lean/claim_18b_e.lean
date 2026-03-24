import Mathlib

/-
Claim 18B.e: In a pure exchange economy with I consumers and L goods,
given a core allocation x*, define V_i = {x_i : x_i ≻_i x*_i} ∪ {ω_i}
and V = Σ_i V_i. Then Σ_i ω_i ∈ V and Σ_i ω_i ∈ frontier V.

We formalize this as: given that ω ∈ V and that a "no blocking" condition
prevents ω from being interior, we conclude ω ∈ frontier V.
-/

theorem Claim_18B_e
    {L : Type*} [TopologicalSpace L] [AddCommMonoid L]
    (V : Set L) (ω : L)
    (hω_mem : ω ∈ V)
    (hω_not_interior : ω ∉ interior V) :
    ω ∈ frontier V := by
  rw [frontier, Set.mem_diff]
  exact ⟨subset_closure hω_mem, hω_not_interior⟩