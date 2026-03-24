import Mathlib

/-- A mechanism can be made self-policing if there exists some modification
    under which participants have no incentive to deviate from truthful behavior.
    Implicit Assumption III.A (Vickrey 1961): The second-price method can be made
    self-policing, even if not automatically to the same extent as first-price. -/
def CanBeMadeSelfPolicing {Mechanism : Type*}
    (isSelfPolicing : Mechanism → Prop) (m : Mechanism) : Prop :=
  ∃ modify : Mechanism → Mechanism, isSelfPolicing (modify m)