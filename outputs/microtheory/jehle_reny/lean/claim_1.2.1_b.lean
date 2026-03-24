import Mathlib

/-- The strict preference relation ≻ and the indifference relation ∼ derived from
a transitive weak preference relation ≿ are both transitive. -/
theorem Claim_1_2_1_b
    {X : Type*}
    (pref : X → X → Prop)
    (htrans : ∀ x y z : X, pref x y → pref y z → pref x z) :
    let strict := fun x y => pref x y ∧ ¬pref y x
    let indiff := fun x y => pref x y ∧ pref y x
    (∀ x y z, strict x y → strict y z → strict x z) ∧
    (∀ x y z, indiff x y → indiff y z → indiff x z) := by
  constructor
  · intro x y z ⟨hxy, hyx⟩ ⟨hyz, hzy⟩
    exact ⟨htrans x y z hxy hyz, fun hzx => hzy (htrans z x y hzx hxy)⟩
  · intro x y z ⟨hxy, hyx⟩ ⟨hyz, hzy⟩
    exact ⟨htrans x y z hxy hyz, htrans z y x hzy hyx⟩