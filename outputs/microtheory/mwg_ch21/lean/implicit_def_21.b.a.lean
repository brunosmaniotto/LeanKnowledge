import Mathlib

def nPlus {I : Type*} [Fintype I] (a : I → Int) : ℕ := (Finset.univ.filter fun i => a i = 1).card