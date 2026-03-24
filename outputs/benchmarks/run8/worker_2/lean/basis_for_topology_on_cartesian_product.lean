import Mathlib

open TopologicalSpace

theorem product_basis (A1 : Type u) [TopologicalSpace A1] (A2 : Type v) [TopologicalSpace A2] :
    IsTopologicalBasis (Set.image2 (fun (U : Set A1) (V : Set A2) => U ×ˢ V) {U | IsOpen U} {V | IsOpen V}) :=
  IsTopologicalBasis.prod (isTopologicalBasis_opens (α := A1)) (isTopologicalBasis_opens (α := A2))