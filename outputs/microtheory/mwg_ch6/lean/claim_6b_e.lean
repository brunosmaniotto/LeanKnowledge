import Mathlib

-- We work with an abstract type of lotteries and a preference relation
variable {L : Type*}

-- Mix operation: αL + (1-α)L'
variable (mix : L → L → (Set.Ioo (0:ℝ) 1) → L)

-- Weak preference relation ≿
variable (pref : L → L → Prop)

-- Independence axiom: L ≿ L' iff mix(L, L'', α) ≿ mix(L', L'', α)
variable (independence : ∀ (a b c : L) (α : Set.Ioo (0:ℝ) 1),
  pref a b ↔ pref (mix a c α) (mix b c α))

-- Strict preference
def strictPref (pref : L → L → Prop) (a b : L) : Prop := pref a b ∧ ¬ pref b a

-- Indifference