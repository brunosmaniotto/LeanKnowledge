import Mathlib

variable (S : Type) (mul : S → S → S)

/-- The sequence of n-ary operations defined recursively from a binary operation. -/
noncomputable def general_operation : ∀ (n : ℕ) (hn : n ≥ 1), (Fin n → S) → S
  | 1, _, f => f 0
  | n + 2, hn, f =>
      have : n + 1 ≥ 1 := by omega
      mul (general_operation (n + 1) this (f ∘ Fin.castSucc)) (f (Fin.last (n + 1)))

theorem general_operation_base (f : Fin 1 → S) :
    general_operation S mul 1 (by omega) f = f 0 := rfl