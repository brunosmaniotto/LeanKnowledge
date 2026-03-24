import Mathlib

variable {T X I : Type*}

structure Mechanism (T X I : Type*) where
  q : T → X
  c : I → T → ℝ

variable (IsExPostEfficient : X → T → Prop)

noncomputable def ExPostEfficient (M : Mechanism T X I) : Prop :=
  ∀ t, IsExPostEfficient (M.q t) t

variable (IncentiveCompatible : Mechanism T X I → Prop)

variable (h_unique : ∀ t, ∃! x, IsExPostEfficient x t)

variable (Theorem_9_14 : ∀ (M1 M2 : Mechanism T X I),
  IncentiveCompatible M1 → IncentiveCompatible M2 → M1.q = M2.q →
  ∃ (c_const : I → ℝ), ∀ i t, M2.c i t = M1.c i t + c_const i)