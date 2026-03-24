import Mathlib
open BigOperators

/-- A normative representative consumer relative to a social welfare function W.
    Given J consumers with individual demands, a wealth distribution rule,
    and a representative preference ≿, the representative is "normative" if
    the wealth distribution solves the social welfare maximization problem
    at every price-wealth pair. -/
structure NormativeRepresentativeConsumer
    (L : ℕ)           -- number of commodities
    (J : ℕ)           -- number of consumers
    where
  /-- Individual demand functions xᵢ(p, wᵢ) -/
  individualDemand : Fin J → (Fin L → ℝ) → ℝ → (Fin L → ℝ)
  /-- Wealth distribution rule: (p, w) ↦ (w₁, ..., w_J) -/
  wealthDistribution : (Fin L → ℝ) → ℝ → Fin J → ℝ
  /-- Aggregate demand x(p, w) = Σᵢ xᵢ(p, wᵢ(p, w)) -/
  aggregateDemand : (Fin L → ℝ) → ℝ → (Fin L → ℝ)
  /-- Individual indirect utility functions vᵢ(p, wᵢ) -/
  indirectUtility : Fin J → (Fin L → ℝ) → ℝ → ℝ
  /-- Social welfare function W(u₁, ..., u_J) -/
  socialWelfare : (Fin J → ℝ) → ℝ
  /-- Indirect utility function for the representative preference ≿ -/
  representativeIndirectUtility : (Fin L → ℝ) → ℝ → ℝ
  /-- Aggregate demand equals sum of individual demands at distributed wealth -/
  aggregate_eq :
    ∀ (p : Fin L → ℝ) (w : ℝ),
      aggregateDemand p w = fun l =>
        ∑ j : Fin J, individualDemand j p (wealthDistribution p w j) l
  /-- Wealth distribution sums to total wealth -/
  wealth_feasible :
    ∀ (p : Fin L → ℝ) (w : ℝ),
      ∑ j : Fin J, wealthDistribution p w j = w
  /-- The wealth distribution maximizes social welfare:
      W(v₁(p,w₁),...,v_J(p,w_J)) ≥ W(v₁(p,w₁'),...,v_J(p,w_J'))
      for all feasible redistributions (w₁',...,w_J') summing to w -/
  welfare_optimal :
    ∀ (p : Fin L → ℝ) (w : ℝ) (w' : Fin J → ℝ),
      ∑ j, w' j = w →
        socialWelfare (fun j => indirectUtility j p (wealthDistribution p w j))
        ≥ socialWelfare (fun j => indirectUtility j p (w' j))
  /-- The value function of the welfare maximization problem equals
      the representative indirect utility -/
  value_eq_representative :
    ∀ (p : Fin L → ℝ) (w : ℝ),
      socialWelfare (fun j => indirectUtility j p (wealthDistribution p w j))
      = representativeIndirectUtility p w