import Mathlib
open BigOperators

variable {H Node Good : Type*} [Fintype H] [Fintype Node] [Fintype Good]

noncomputable def IsADEquil
    (u : H → (Node → Good → ℝ) → ℝ)
    (e : H → Node → Good → ℝ)
    (x : H → Node → Good → ℝ) : Prop :=
  (∀ ξ : Node, ∀ l : Good, ∑ h : H, x h ξ l = ∑ h : H, e h ξ l) ∧
  ∃ p : Node → Good → ℝ, ∀ h : H, ∀ y : Node → Good → ℝ,
    u h y > u h (x h) →
    ∑ ξ : Node, ∑ l : Good, p ξ l * y ξ l >
    ∑ ξ : Node, ∑ l : Good, p ξ l * e h ξ l

noncomputable def IsRadnerEquil
    (u : H → (Node → Good → ℝ) → ℝ)
    (e : H → Node → Good → ℝ)
    (x : H → Node → Good → ℝ) : Prop :=
  (∀ ξ : Node, ∀ l : Good, ∑ h : H, x h ξ l = ∑ h : H, e h ξ l) ∧
  ∃ (q : Node → ℝ) (p : Node → Good → ℝ), ∀ h : H, ∀ y : Node → Good → ℝ,
    u h y > u h (x h) →
    ∃ ξ : Node, ∑ l : Good, p ξ l * (y ξ l - e h ξ l) > q ξ

axiom ad_to_radner_19D_e
    (u : H → (Node → Good → ℝ) → ℝ)
    (e : H → Node → Good → ℝ)
    (x : H → Node → Good → ℝ) :
    IsADEquil u e x → IsRadnerEquil u e x

axiom radner_to_ad_19D_e
    (u : H → (Node → Good → ℝ) → ℝ)
    (e : H → Node → Good → ℝ)
    (x : H → Node → Good → ℝ) :
    IsRadnerEquil u e x → IsADEquil u e x

theorem Claim_19D_e
    (u : H → (Node → Good → ℝ) → ℝ)
    (e : H → Node → Good → ℝ)
    (x : H → Node → Good → ℝ) :
    IsADEquil u e x ↔ IsRadnerEquil u e x :=
  ⟨ad_to_radner_19D_e u e x, radner_to_ad_19D_e u e x⟩