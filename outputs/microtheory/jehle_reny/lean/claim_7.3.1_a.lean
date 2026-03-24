import Mathlib

/-- An extensive form game has **perfect information** if every information set
    is a singleton, i.e., each information set contains exactly one decision node.
    This means no player is ever uncertain about which node they are at. -/
def ExtensiveFormGame.isPerfectInformation
    {Node : Type*} {Player : Type*}
    (infoSets : Player → Finset (Finset Node))
    : Prop :=
  ∀ (i : Player) (H : Finset Node), H ∈ infoSets i → H.card = 1