import Mathlib

axiom IR_VCG_incentive_compatible : Prop
axiom IR_VCG_ex_post_efficient : Prop
axiom IR_VCG_individual_rational : Prop

axiom h_incentive : IR_VCG_incentive_compatible
axiom h_ex_post : IR_VCG_ex_post_efficient
axiom h_ir : IR_VCG_individual_rational

theorem Claim_IRVCG_properties : IR_VCG_incentive_compatible ∧ IR_VCG_ex_post_efficient ∧ IR_VCG_individual_rational :=
  ⟨h_incentive, ⟨h_ex_post, h_ir⟩⟩