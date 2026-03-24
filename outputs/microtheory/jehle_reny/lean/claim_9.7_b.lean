import Mathlib

open BigOperators
open Finset

noncomputable section

-- Types: discrete uniform over {0,1,2}
abbrev TypeSet : Type := Fin 3

-- Social states from Example 9.6
inductive SocialState
  | S  -- swimming pool
  | B  -- books
  | D  -- don't build

open SocialState

-- Valuation functions
def v1 : SocialState → TypeSet → ℚ
  | S, t => 5 + (t : ℚ)
  | B, _ => 5
  | D, _ => 10