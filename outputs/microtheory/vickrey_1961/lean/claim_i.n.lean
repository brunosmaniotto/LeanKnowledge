import Mathlib

open Classical

/-- A source of public funds exists without adverse influence on resource allocation in other directions. -/
axiom PublicFunds.has_source_without_adverse_influence_on_resource_allocation : Prop

/-- The marketing agency scheme permits optimum allocation of resources. -/
axiom MarketingAgencyScheme.permits_optimum_resource_allocation : Prop

/-- The marketing agency scheme would permit optimum allocation of resources if there were a source of public funds without adverse influence on resource allocation in other directions. -/
def Claim_I.N : Prop :=
  PublicFunds.has_source_without_adverse_influence_on_resource_allocation →
  MarketingAgencyScheme.permits_optimum_resource_allocation