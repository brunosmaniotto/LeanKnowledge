import Mathlib

variable [LinearOrder S] [Preorder T] {φ : S → T}

theorem strictMono_injective (hφ : StrictMono φ) : Function.Injective φ := by
  intro x y h
  by_cases hxy : x = y
  · exact hxy
  · exfalso
    rcases lt_trichotomy x y with (hlt | heq | hgt)
    · exact (hφ hlt).ne h
    · exact hxy heq
    · exact (hφ hgt).ne (Eq.symm h)