import Mathlib

-- Sub-lemmas
lemma kernel_equiv_is_congruence {S T : Type*} [Mul S] [Mul T] (φ : S →ₙ* T) : 
  ∀ a b c d : S, (φ a = φ b) → (φ c = φ d) → (φ (a * c) = φ (b * d)) := by
  intros a b c d hab hcd
  rw [φ.map_mul, hab, hcd, ← φ.map_mul]