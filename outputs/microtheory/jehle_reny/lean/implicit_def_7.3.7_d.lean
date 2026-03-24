import Mathlib

/-- Common beliefs principle: Players with identical information have identical beliefs.
    Given a type of players, information sets, and a belief type,
    a belief assignment satisfies the common beliefs principle if
    whenever two players have the same information, they hold the same beliefs. -/
def CommonBeliefsPrinciple
    {Player : Type*} {InfoSet : Type*} {Belief : Type*}
    (info : Player → InfoSet)
    (beliefs : Player → Belief) : Prop :=
  ∀ i j : Player, info i = info j → beliefs i = beliefs j