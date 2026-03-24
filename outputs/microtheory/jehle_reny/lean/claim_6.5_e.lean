import Mathlib
open Classical -- For using classical logic (e.g., in `IsStrictlyPreferred` where `¬` is involved)

-- Common variables for social choice theory framework
variable {I A : Type*} [Fintype I] [Fintype A] [DecidableEq A] [Nonempty A] [Nonempty I]

-- Definition of a preference relation (weak preference)
def PreferenceRelation := A → A → Prop

-- Definition of strict preference based on a weak preference relation