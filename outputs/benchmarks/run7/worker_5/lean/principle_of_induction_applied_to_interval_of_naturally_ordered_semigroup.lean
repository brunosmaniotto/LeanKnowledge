import Mathlib

open Set

theorem interval_induction (T : Set ℕ) (p q : ℕ) (hT_sub : T ⊆ Set.Icc p q) (hmin : p ∈ T)
    (hstep : ∀ x ∈ T, x < q → x + 1 ∈ T) : T = Set.Icc p q := by
  have hpq : p ≤ q := (hT_sub hmin).right
  ext x
  constructor
  · intro hx
    exact hT_sub hx
  · intro hx
    rcases hx with ⟨hx_left, hx_right⟩
    let P : ℕ → Prop := fun k => k ≤ q → k ∈ T
    have h_base : P p := by
      intro _
      exact hmin
    have h_step_ind : ∀ k, p ≤ k → (P k → P (k + 1)) := by
      intro k hpk hPk
      intro hk1
      have hk : k ≤ q := by omega
      have hk_mem : k ∈ T := hPk hk
      have hk_lt : k < q := by omega
      exact hstep k hk_mem hk_lt
    have hx_P : P x := Nat.le_induction h_base h_step_ind x hx_left
    exact hx_P hx_right