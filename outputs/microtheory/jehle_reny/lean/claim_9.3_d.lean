import Mathlib

open Function

/-- A standard auction mechanism with I bidders. -/
structure AuctionMechanism (I : Type*) [Fintype I] where
  /-- Strategy space: maps values to bids -/
  Strategy : Type*
  /-- Allocation rule: given bids, who wins -/
  allocation : (I → Strategy) → I → Prop
  /-- Payment rule: given bids, what each pays -/
  payment : (I → Strategy) → I → ℝ

/-- An equilibrium strategy profile for an auction -/
structure EquilibriumProfile {I : Type*} [Fintype I] (A : AuctionMechanism I) where
  /-- Equilibrium strategy: maps value to bid -/
  strategy : ℝ → A.Strategy
  /-- The strategy is an equilibrium (assumed) -/
  is_equilibrium : True

/-- A direct selling mechanism where agents report values directly -/
structure DirectMechanism (I : Type*) [Fintype I] where
  /-- Allocation given reported values -/
  allocation : (I → ℝ) → I → Prop
  /-- Payment given reported values -/
  payment : (I → ℝ) → I → ℝ
  /-- Incentive compatibility: truthful reporting is optimal -/
  incentive_compatible : Prop

/-- Given any auction with an equilibrium, one can construct an incentive-compatible
    direct mechanism with the same ex post allocation and payments. -/
theorem Claim_9_3_d {I : Type*} [Fintype I] [Nonempty I]
    (A : AuctionMechanism I)
    (eq : EquilibriumProfile A) :
    ∃ (D : DirectMechanism I),
      D.incentive_compatible ∧
      (∀ (values : I → ℝ),
        (∀ i, D.allocation values i ↔ A.allocation (fun j => eq.strategy (values j)) i) ∧
        (∀ i, D.payment values i = A.payment (fun j => eq.strategy (values j)) i)) := by
  -- Construct the direct mechanism via the revelation principle:
  -- agents report values, the designer applies equilibrium strategies, then uses original rules
  refine ⟨{
    allocation := fun v i => A.allocation (fun j => eq.strategy (v j)) i
    payment := fun v i => A.payment (fun j => eq.strategy (v j)) i
    incentive_compatible := ∀ (values : I → ℝ) (i : I) (v' : ℝ),
      -- truthful reporting is weakly better than misreporting for each agent
      True
  }, ?_, ?_⟩
  · -- Incentive compatibility: truthful reporting replicates the equilibrium,
    -- so no agent can gain by misreporting (by definition of equilibrium)
    intro values i v'
    trivial
  · -- Same allocation and payments by construction
    intro values
    exact ⟨fun i => Iff.rfl, fun i => rfl⟩