import Mathlib

/-- A social choice function assigns a collective choice in `X` to each profile
of agent types. Agent `i : ι` has type space `Θ i`, and the function selects
an outcome in `X` for every type profile `θ : (i : ι) → Θ i`. -/
abbrev SocialChoiceFunction (ι : Type*) (Θ : ι → Type*) (X : Type*) :=
  ((i : ι) → Θ i) → X