import Mathlib

/-- Data for a two-type sequential equilibrium in an insurance signaling game.
    `β` is the belief function giving the probability placed on the low-risk type. -/
structure TwoTypeSignalingEquilibrium (Policy : Type*) where
  /-- Equilibrium policy for the low-risk consumer -/
  ψ_l : Policy
  /-- Equilibrium policy for the high-risk consumer -/
  ψ_h : Policy
  /-- Utility of the low-risk consumer from a policy -/
  u_l : Policy → ℝ
  /-- Utility of the high-risk consumer from a policy -/
  u_h : Policy → ℝ
  /-- Belief function: probability assigned to low-risk type at each policy -/
  β : Policy → ℝ

/-- (Cho–Kreps) Intuitive Criterion. A two-type sequential equilibrium satisfies
    the intuitive criterion if, for every off-equilibrium policy ψ, whenever exactly
    one type strictly gains from deviating to ψ while the other strictly loses,
    the belief at ψ places probability one on the deviating type.
    Convention: β(ψ) = probability of low-risk type. -/
def SatisfiesIntuitiveCriterion {Policy : Type*}
    (E : TwoTypeSignalingEquilibrium Policy) : Prop :=
  let u_l_star := E.u_l E.ψ_l
  let u_h_star := E.u_h E.ψ_h
  ∀ ψ : Policy, ψ ≠ E.ψ_l → ψ ≠ E.ψ_h →
    -- Low-risk type gains, high-risk type loses ⟹ belief = 1 (low-risk)
    (E.u_l ψ > u_l_star ∧ E.u_h ψ < u_h_star → E.β ψ = 1) ∧
    -- High-risk type gains, low-risk type loses ⟹ belief = 0 (high-risk)
    (E.u_h ψ > u_h_star ∧ E.u_l ψ < u_l_star → E.β ψ = 0)