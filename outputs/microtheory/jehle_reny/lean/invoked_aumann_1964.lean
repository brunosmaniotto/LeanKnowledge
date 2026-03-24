import Mathlib
open Topology

/-- Aumann (1964), Hildenbrand (1974), and others proved even stronger core convergence
results in the setting of continuum economies, without the assumption of equal numbers
of each type of consumer. -/
theorem Invoked_Aumann_1964
    {Ω : Type*} {X : Type*}
    (IsCoreAllocation : (Ω → X) → Prop)
    (IsWalrasianEquilibrium : (Ω → X) → Prop)
    (continuum_core_equivalence :
      ∀ a, IsCoreAllocation a ↔ IsWalrasianEquilibrium a)
    (no_equal_type_assumption : True)
    (a : Ω → X) :
    IsCoreAllocation a ↔ IsWalrasianEquilibrium a :=
  continuum_core_equivalence a