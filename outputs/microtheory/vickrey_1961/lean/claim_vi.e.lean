import Mathlib
open Topology

/--
The proposition that in many markets, the frequency of dealings and the
professional characteristics of the dealers are such as to make the assumption
of high rationality and sophistication in bidders not too far from reality.
-/
axiom HighRationalityAndSophisticationAssumptionIsRealistic : Prop

-- We introduce an axiom that asserts the truth of the proposition, since it's an
-- empirical claim, not a mathematically provable statement.
axiom highRationalityAndSophisticationAssumptionIsRealistic_axiom : HighRationalityAndSophisticationAssumptionIsRealistic

theorem Claim_VI.E : HighRationalityAndSophisticationAssumptionIsRealistic :=
  highRationalityAndSophisticationAssumptionIsRealistic_axiom