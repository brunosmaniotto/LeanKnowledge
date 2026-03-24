import Mathlib
open Topology

/-- No selling mechanism yields more revenue than the revenue-maximising
    incentive-compatible direct selling mechanism. By the revelation principle,
    any mechanism has an equivalent IC direct mechanism with the same revenue. -/
theorem claim_9_4_1_b
    {Mechanism : Type*} {ICDirect : Type*}
    (revenue : Mechanism → ℝ)
    (revenue_ic : ICDirect → ℝ)
    -- Every IC direct mechanism is (embeds into) a mechanism
    (embed : ICDirect → Mechanism)
    (embed_rev : ∀ d : ICDirect, revenue (embed d) = revenue_ic d)
    -- Revelation principle: every mechanism has an equivalent IC direct mechanism
    (revelation : ∀ m : Mechanism, ∃ d : ICDirect, revenue_ic d = revenue m)
    -- There exists an optimal IC direct mechanism
    (opt : ICDirect)
    (opt_spec : ∀ d : ICDirect, revenue_ic d ≤ revenue_ic opt) :
    -- Then: for ALL mechanisms, the optimal IC direct mechanism does at least as well
    ∀ m : Mechanism, revenue m ≤ revenue_ic opt := by
  intro m
  obtain ⟨d, hd⟩ := revelation m
  calc revenue m = revenue_ic d := hd.symm
    _ ≤ revenue_ic opt := opt_spec d