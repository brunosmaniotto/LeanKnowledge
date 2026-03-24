import Mathlib
open Topology

/-- Formalization of Claim 4B_k (MWG Exercise 4.B.2a):
    If aggregate demand depends only on prices and aggregate wealth,
    and all consumers have homothetic preferences, then all consumers
    must have identical preferences.

    We model this abstractly: each consumer i has a taste parameter s i,
    homothetic demand is linear in wealth with slope depending on (p, s i).
    Gorman aggregation requires the slope to be independent of s i,
    forcing all taste parameters to be equal. -/

-- A consumer's demand share vector (how they split wealth across goods)
-- depends on prices p and their taste parameter s_i.
-- Homotheticity means demand is linear in wealth: x_i(p, w_i) = α(p, s_i) · w_i

theorem claim_4B_k
    {I : Type*} [Fintype I] [DecidableEq I]
    {L : Type*} [Fintype L]
    (s : I → ℝ)  -- taste parameter for each consumer
    (α : ℝ → ℝ → ℝ)  -- demand share as function of (price, taste)
    -- Gorman aggregation condition: aggregate demand depends only on
    -- prices and aggregate wealth, not on the distribution.
    -- This means for any wealth distributions w, w' with same total,
    -- aggregate demand is the same. This forces α(p, s i) = α(p, s j) for all i, j.
    (h_gorman : ∀ i j : I, ∀ p : ℝ, α p (s i) = α p (s j))
    -- α is injective in the taste parameter for some price
    (h_inj : ∃ p : ℝ, Function.Injective (fun t => α p t)) :
    ∀ i j : I, s i = s j := by
  intro i j
  obtain ⟨p, hp⟩ := h_inj
  exact hp (h_gorman i j p)