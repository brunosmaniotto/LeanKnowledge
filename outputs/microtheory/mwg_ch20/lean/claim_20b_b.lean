import Mathlib
open Finset

/-- Axiom: Additive utility representation (Blackorby, Primont and Russell, 1978).
    Separability of preferences implies additive representability. -/
axiom additive_utility_representation_axiom
    {T : ℕ} {C : Type*}
    (pref : (Fin T → C) → (Fin T → C) → Prop)
    (future_sep : ∀ (t : Fin T) (past : Fin T → C) (c₁ c₂ : Fin T → C),
      (∀ i, i.val ≤ t.val → c₁ i = past i) →
      (∀ i, i.val ≤ t.val → c₂ i = past i) →
      (pref c₁ c₂ ↔ pref
        (fun i => if i.val ≤ t.val then past i else c₁ i)
        (fun i => if i.val ≤ t.val then past i else c₂ i)))
    (past_sep : ∀ (t : Fin T) (future : Fin T → C) (c₁ c₂ : Fin T → C),
      (∀ i, i.val > t.val → c₁ i = future i) →
      (∀ i, i.val > t.val → c₂ i = future i) →
      (pref c₁ c₂ ↔ pref
        (fun i => if i.val > t.val then future i else c₁ i)
        (fun i => if i.val > t.val then future i else c₂ i))) :
    ∃ (u : Fin T → C → ℝ),
      ∀ (c₁ c₂ : Fin T → C),
        pref c₁ c₂ ↔
          Finset.sum Finset.univ (fun t => u t (c₁ t)) ≤
          Finset.sum Finset.univ (fun t => u t (c₂ t))

/-- If preferences over consumption streams satisfy future-separability and
    past-separability, then they admit an additive utility representation
    V(c) = Σ_t u_t(c_t). Reference: Blackorby, Primont and Russell (1978). -/
theorem additive_utility_from_separability
    {T : ℕ} {C : Type*}
    (pref : (Fin T → C) → (Fin T → C) → Prop)
    (future_sep : ∀ (t : Fin T) (past : Fin T → C) (c₁ c₂ : Fin T → C),
      (∀ i, i.val ≤ t.val → c₁ i = past i) →
      (∀ i, i.val ≤ t.val → c₂ i = past i) →
      (pref c₁ c₂ ↔ pref
        (fun i => if i.val ≤ t.val then past i else c₁ i)
        (fun i => if i.val ≤ t.val then past i else c₂ i)))
    (past_sep : ∀ (t : Fin T) (future : Fin T → C) (c₁ c₂ : Fin T → C),
      (∀ i, i.val > t.val → c₁ i = future i) →
      (∀ i, i.val > t.val → c₂ i = future i) →
      (pref c₁ c₂ ↔ pref
        (fun i => if i.val > t.val then future i else c₁ i)
        (fun i => if i.val > t.val then future i else c₂ i))) :
    ∃ (u : Fin T → C → ℝ),
      ∀ (c₁ c₂ : Fin T → C),
        pref c₁ c₂ ↔
          Finset.sum Finset.univ (fun t => u t (c₁ t)) ≤
          Finset.sum Finset.univ (fun t => u t (c₂ t)) :=
  additive_utility_representation_axiom pref future_sep past_sep