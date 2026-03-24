import Mathlib

/-- A preference relation on `X`. `PreferenceRelation X` is a binary relation
    where `r x y` reads as "x is at least as good as y." -/
abbrev PreferenceRelation (X : Type*) := X → X → Prop

namespace PreferenceRelation

/-- Notation: `x ≿[r] y` means "x is at least as good as y" under relation `r`. -/
scoped notation:50 x " ≿[" r "] " y => r x y

end PreferenceRelation