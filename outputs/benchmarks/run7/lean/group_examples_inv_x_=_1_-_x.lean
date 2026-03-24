import Mathlib

noncomputable section

def S : Set ℝ := Set.Ioo (0 : ℝ) 1

noncomputable def e : S ≃ ℝ where
  toFun := fun x => Real.log ((1 - (x : ℝ)) / (x : ℝ))
  invFun := fun z => ⟨1 / (1 + Real.exp z), by
    have exp_pos : 0 < Real.exp z := Real.exp_pos z
    constructor
    · positivity
    · exact (div_lt_one (by linarith)).mpr (by linarith)⟩
  left_inv := by
    intro x
    ext
    dsimp
    have hx : 0 < (x : ℝ) := x.2.1
    have h1x : (x : ℝ) < 1 := x.2.2
    have h : 0 < (1 - (x : ℝ)) / (x : ℝ) := div_pos (by linarith) hx
    rw [Real.exp_log h]
    field_simp
    ring
  right_inv := by
    intro z
    dsimp
    have : (1 - 1 / (1 + Real.exp z)) / (1 / (1 + Real.exp z)) = Real.exp z := by
      field_simp
      ring
    rw [this, Real.log_exp]

noncomputable instance : AddGroup S :=
  Equiv.addGroup e