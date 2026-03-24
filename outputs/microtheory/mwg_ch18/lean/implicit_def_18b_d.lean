import Mathlib
open BigOperators
open Topology

/-- A type allocation assigns a bundle in ℝ^L to each type h ∈ Fin H -/
abbrev TypeAllocation (L H : ℕ) := Fin H → Fin L → ℝ

/-- C_N: the set of feasible type allocations for which the equal-treatment
    allocations induced in the N-replica economy have the core property.
    Parameters: L = number of goods, H = number of types, N = replica count,
    ω = endowments per type, preferred = strict preference per type. -/
noncomputable def C_N (L H N : ℕ) [NeZero N]
    (ω : Fin H → Fin L → ℝ)
    (preferred : Fin H → (Fin L → ℝ) → (Fin L → ℝ) → Prop)
    : Set (TypeAllocation L H) :=
  {x | -- Feasibility: total consumption equals total endowment
    (∀ l : Fin L, ∑ h : Fin H, x h l = ∑ h : Fin H, ω h l) ∧
    -- Core property in the N-replica: no coalition can block
    (∀ (S : Finset (Fin N × Fin H)), S.Nonempty →
      ¬∃ y : Fin N × Fin H → Fin L → ℝ,
        (∀ i ∈ S, preferred i.2 (y i) (x i.2)) ∧
        (∀ l : Fin L, ∑ i ∈ S, y i l = ∑ i ∈ S, ω i.2 l))}