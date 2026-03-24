import Mathlib

open Set

def continuous_functions_submodule (a b : ℝ) : Submodule ℝ (↥(Icc a b) → ℝ) :=
  {
    carrier := {f | Continuous f}
    zero_mem' := continuous_const
    add_mem' := fun hf hg => Continuous.add hf hg
    smul_mem' := fun c f hf => Continuous.const_smul hf c
  }