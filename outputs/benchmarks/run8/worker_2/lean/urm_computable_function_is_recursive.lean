import Mathlib

axiom URMComputable : ∀ {k : ℕ}, (Vector ℕ k → ℕ) → Prop
axiom Recursive : ∀ {k : ℕ}, (Vector ℕ k → ℕ) → Prop

theorem URM_Computable_Function_is_Recursive {k : ℕ} (f : Vector ℕ k → ℕ)
    (h : URMComputable f) : Recursive f := by
  sorry