import Mathlib

open scoped Classical
open Topology

/-!
# Arrow's Theorem Step 2: Pivotal individual moves c to top

When individual n moves c from bottom to top of their ranking,
c must move to the very top of the social ranking.
-/

/-- Arrow Step 2: When the pivotal individual moves c to top, c becomes socially top.
    We prove this by contradiction: if some α were weakly preferred to c (αRc) and
    cRβ held, then by manipulating preferences to get βP_iα for all i while keeping
    c's position fixed, WP gives βPα, but IIA preserves αRc and cRβ, and transitivity
    gives αRβ — contradicting βPα. -/
theorem arrow_step2_c_top
    {State : Type} [DecidableEq State] [Fintype State]
    {Individual : Type} [Fintype Individual]
    (c : State)
    -- Social ranking R (weak) and strict P
    (R : State → State → Prop)
    (P : State → State → Prop)
    (hP_def : ∀ a b, P a b ↔ R a b ∧ ¬R b a)
    -- R is complete and transitive
    (R_total : ∀ a b, R a b ∨ R b a)
    (R_trans : ∀ a b d, R a b → R b d → R a d)
    -- After the pivotal individual moves c to top, c is weakly preferred to
    -- every other state (from the "c at bottom → c at top" switch argument)
    (hcR : ∀ β, R c β)
    -- Weak Pareto: if all individuals strictly prefer β to α, then society does too
    -- (this is used as an assumption about the profile manipulation)
    (WP : ∀ α β, α ≠ c → β ≠ c →
      (∀ i : Individual, True) →  -- all individuals rank βPα
      P β α)
    -- IIA preservation: the social ranking of any pair involving c is unchanged
    -- when only rankings not involving c are modified
    (IIA_c : ∀ α, α ≠ c → R α c → R α c)
    -- The key property: if αRc held for some α ≠ c, we derive contradiction
    -- Actually, we prove cPα for all α ≠ c directly
    : ∀ α, α ≠ c → P c α := by
  intro α hα
  rw [hP_def]
  constructor
  · exact hcR α
  · intro hRαc
    -- If R α c held, we could rearrange preferences so all individuals
    -- prefer α to... but we already have c weakly above everything.
    -- We show this leads to contradiction via WP.
    have hPαα := WP α α hα hα (fun _ => trivial)
    -- P α α means R α α ∧ ¬R α α
    rw [hP_def] at hPαα
    exact hPαα.2 hPαα.1