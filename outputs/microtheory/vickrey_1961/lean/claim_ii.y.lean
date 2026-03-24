import Mathlib

theorem Claim_II_Y_existence_of_deterministic_strategy {Value Bid : Type*} [Nonempty Bid] :
    Nonempty (Value → Bid) := by
  -- Since `Bid` is non-empty, we can pick an arbitrary element `b₀` from `Bid`.
  cases' ‹Nonempty Bid› with b₀
  -- Now we can construct a function that maps every element of `Value` to `b₀`.
  let f : Value → Bid := fun _ => b₀
  -- This function `f` serves as a witness that `Value → Bid` is non-empty.
  exact Nonempty.intro f