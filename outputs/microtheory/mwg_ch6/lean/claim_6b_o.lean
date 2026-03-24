import Mathlib

-- We prove that independence implies convexity of strict preference:
-- if L ≻ L' and L ≻ L'', then L ≻ αL' + (1-α)L''

-- Model lotteries with a mixture space structure
variable {L : Type*} [DecidableEq L]

-- Abstract mixture operation: mix α p q = αp + (1-α)q
variable (mix : ℝ → L → L → L)

-- Preference relation (weak): p ≿ q
variable (pref : L → L → Prop)

-- Strict preference: p ≻ q iff p ≿ q and ¬(q ≿ p)
def StrictPref (pref : L → L → Prop) (p q : L) : Prop :=
  pref p q ∧ ¬ pref q p

-- Independence axiom: for all p, q, r and α ∈ (0,1],
-- p ≿ q ↔ mix α p r ≿ mix α q r