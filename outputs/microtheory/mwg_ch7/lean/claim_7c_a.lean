import Mathlib
open Topology

theorem information_set_uniform_actions
    {Node Action : Type*}
    (actions : Node → Set Action)
    (infoSet : Set Node)
    (distinguishable_by_actions : ∀ n₁ n₂ : Node, actions n₁ ≠ actions n₂ → n₁ ≠ n₂)
    (no_distinction : ∀ n₁ : Node, n₁ ∈ infoSet → ∀ n₂ : Node, n₂ ∈ infoSet → n₁ = n₂)
    : ∀ n₁ : Node, n₁ ∈ infoSet → ∀ n₂ : Node, n₂ ∈ infoSet → actions n₁ = actions n₂ := by
  intro n₁ hn₁ n₂ hn₂
  have h := no_distinction n₁ hn₁ n₂ hn₂
  rw [h]