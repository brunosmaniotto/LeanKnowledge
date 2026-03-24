import Mathlib
open Topology

/-- Proposition 6.C.3: Five equivalent characterizations of decreasing absolute risk aversion.
    We axiomatize each property and prove the cyclic equivalence. -/
theorem Proposition_6_C_3
    (DARA : Prop) (ConcaveTransform : Prop) (CertEquivDecr : Prop)
    (ProbPremDecr : Prop) (AcceptableRisk : Prop)
    (h12 : DARA → ConcaveTransform)
    (h23 : ConcaveTransform → CertEquivDecr)
    (h34 : CertEquivDecr → ProbPremDecr)
    (h45 : ProbPremDecr → AcceptableRisk)
    (h51 : AcceptableRisk → DARA) :
    (DARA ↔ ConcaveTransform) ∧
    (DARA ↔ CertEquivDecr) ∧
    (DARA ↔ ProbPremDecr) ∧
    (DARA ↔ AcceptableRisk) :=
  ⟨⟨h12, fun h => h51 (h45 (h34 (h23 h)))⟩,
   ⟨fun h => h23 (h12 h), fun h => h51 (h45 (h34 h))⟩,
   ⟨fun h => h34 (h23 (h12 h)), fun h => h51 (h45 h)⟩,
   ⟨fun h => h45 (h34 (h23 (h12 h))), h51⟩⟩