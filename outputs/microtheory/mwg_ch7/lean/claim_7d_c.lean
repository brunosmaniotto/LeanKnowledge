import Mathlib
open Topology

-- Abstract types for game representations
axiom ExtensiveForm : Type
axiom NormalForm : Type

-- The mapping from extensive to normal form is a function (hence unique per extensive form)
axiom toNormalForm : ExtensiveForm → NormalForm

-- There exist distinct extensive forms mapping to the same normal form
axiom extensive_form_noninjective :
  ∃ (G₁ G₂ : ExtensiveForm), G₁ ≠ G₂ ∧ toNormalForm G₁ = toNormalForm G₂

/-- For any extensive form game, there is a unique normal form representation.
    The converse is not true: many different extensive forms may yield the same normal form. -/
theorem Claim_7D_c :
    (∀ G : ExtensiveForm, ∃! N : NormalForm, N = toNormalForm G) ∧
    ¬(∀ N : NormalForm, ∃! G : ExtensiveForm, toNormalForm G = N) := by
  constructor
  · -- Forward: each extensive form has a unique normal form
    intro G
    exact ⟨toNormalForm G, rfl, fun N hN => hN⟩
  · -- Converse fails: toNormalForm is not injective
    intro h
    obtain ⟨G₁, G₂, hne, heq⟩ := extensive_form_noninjective
    have ⟨_, _, huniq⟩ := h (toNormalForm G₁)
    have h1 := huniq G₁ rfl
    have h2 := huniq G₂ heq.symm
    exact hne (h1.symm ▸ h2.symm)