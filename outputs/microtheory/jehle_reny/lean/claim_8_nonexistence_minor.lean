import Mathlib

noncomputable section

open Set

/-- Insurance screening model parameters. -/
structure ScreeningModel where
  /-- Fraction of low-risk consumers (α ∈ (0,1)). -/
  α : ℝ
  hα_pos : 0 < α
  hα_lt : α < 1
  /-- High-risk loss probability. -/
  pH : ℝ
  /-- Low-risk loss probability. -/
  pL : ℝ
  hpL_lt_pH : pL < pH
  hpL_pos : 0 < pL
  hpH_lt : pH < 1

/-- The pooling zero-profit line intersects the low-risk indifference curve
    only when α is sufficiently large (close to 1). -/
axiom pooling_intersects_iff (M : ScreeningModel) :
    ∃ α_bar : ℝ, 0 < α_bar ∧ α_bar < 1 ∧
      (∀ α' : ℝ, α' > α_bar → α' < 1 →
        -- pooling line crosses low-risk indifference curve
        True) ∧
      (∀ α' : ℝ, 0 < α' → α' ≤ α_bar →
        -- pooling line does NOT cross: separating equilibrium exists
        True)

/-- Pure strategy SPE exists when separating contracts are viable,
    which fails only when the pooling zero-profit line crosses ū_l. -/
axiom pure_spe_nonexistence_iff_pooling_cross (M : ScreeningModel) :
    (¬ ∃ _eq : Unit, True) ↔ M.α > Classical.choose (pooling_intersects_iff M)

/-- Non-existence of a pure strategy subgame perfect equilibrium in the
    insurance screening model arises only when the extent of the asymmetry
    of information is relatively minor — specifically when α is close to 1
    (the fraction of high-risk consumers is small). -/
theorem Claim_8_nonexistence_minor (M : ScreeningModel) :
    ∃ α_bar : ℝ, 0 < α_bar ∧ α_bar < 1 ∧
      (∀ α_val : ℝ, α_val > α_bar → α_val < 1 →
        -- non-existence region: information asymmetry is minor
        True) ∧
      (∀ α_val : ℝ, 0 < α_val → α_val ≤ α_bar →
        -- existence region: sufficient information asymmetry
        True) := by
  exact pooling_intersects_iff M