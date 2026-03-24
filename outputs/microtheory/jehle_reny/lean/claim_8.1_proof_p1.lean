import Mathlib

/-- In a separating equilibrium where equilibrium policies are accepted:
    (P.1) u_l(ψ_l) ≥ u_l(B, p) follows from condition (3).
    (P.2) u_h(ψ_h) ≥ u_h(B, p) follows from (1), (3), (4) and optimality
    of (L, π̄L) among no-better-than-fair policies. -/
theorem Claim_8_1_proof_P1
    {Contract : Type*}
    (u_l u_h : Contract → ℝ)
    (ψ_l ψ_h : Contract)
    (A : Set Contract)        -- accepted policies with p ≤ w
    (Fair : Set Contract)     -- no-better-than-fair policies
    -- Conditions (1) and (4): accepted policies are no-better-than-fair
    (hA_fair : A ⊆ Fair)
    -- Condition (3): IC for low-risk type — ψ_l weakly preferred to any accepted
    (cond3 : ∀ c ∈ A, u_l ψ_l ≥ u_l c)
    -- (L, π̄L) = ψ_h is best for high-risk among all no-better-than-fair policies
    (hψh_best : ∀ c ∈ Fair, u_h ψ_h ≥ u_h c) :
    (∀ c ∈ A, u_l ψ_l ≥ u_l c) ∧
    (∀ c ∈ A, u_h ψ_h ≥ u_h c) := by
  constructor
  · -- (P.1): directly from condition (3)
    exact cond3
  · -- (P.2): any accepted contract is no-better-than-fair, and ψ_h is optimal there
    intro c hc
    exact hψh_best c (hA_fair hc)