import Mathlib

theorem Infimum_Plus_Constant (T : Set ℝ) (hT : BddBelow T) (hT_ne : T.Nonempty) (ξ : ℝ) :
    sInf {x + ξ | x ∈ T} = ξ + sInf T := by
  set A := {x + ξ | x ∈ T} with hA_def
  have hA_ne : A.Nonempty := by
    rcases hT_ne with ⟨x, hx⟩
    exact ⟨x + ξ, ⟨x, hx, rfl⟩⟩
  rcases hT with ⟨a, ha⟩
  have hA_bdd : BddBelow A := by
    use a + ξ
    intro y hy
    rcases hy with ⟨x, hx, rfl⟩
    have hxa : a ≤ x := ha hx
    linarith
  apply le_antisymm
  · have h : sInf A - ξ ≤ sInf T := by
      apply le_csInf hT_ne
      intro x hx
      have hx' : x + ξ ∈ A := ⟨x, hx, rfl⟩
      have h_inf : sInf A ≤ x + ξ := csInf_le hA_bdd hx'
      linarith
    linarith
  · apply le_csInf hA_ne
    rintro y ⟨x, hx, rfl⟩
    have hx_inf : sInf T ≤ x := csInf_le ⟨a, ha⟩ hx
    linarith