import Mathlib

theorem rational_congruence (R : ℚ → ℚ → Prop) (h_refl : ∀ x, R x x) (h_symm : ∀ x y, R x y → R y x)
    (h_trans : ∀ x y z, R x y → R y z → R x z)
    (h_add : ∀ a b c d, R a b → R c d → R (a + c) (b + d))
    (h_mul : ∀ a b c d, R a b → R c d → R (a * c) (b * d)) :
    (∀ x y, R x y) ∨ (∀ x y, R x y ↔ x = y) := by
  by_cases h : ∃ a b, a ≠ b ∧ R a b
  · rcases h with ⟨a, b, hne, hab⟩
    -- Step 1: 0 R (b - a)
    have h0d : R 0 (b - a) := by
      have h_add' : R (a + (-a)) (b + (-a)) := h_add a b (-a) (-a) hab (h_refl (-a))
      have h1 : a + (-a) = 0 := by ring
      have h2 : b + (-a) = b - a := by ring
      rw [h1, h2] at h_add'
      exact h_add'
    have hd : b - a ≠ 0 := by
      intro h_eq
      apply hne
      linarith
    -- Step 2: For any x, 0 R x
    have h0x : ∀ x, R 0 x := by
      intro x
      have h_symm_h0 : R (b - a) 0 := h_symm 0 (b - a) h0d
      set y := x / (b - a) with hy_def
      have h_refl_y : R y y := h_refl y
      have h_mul1 : R (y * (b - a)) (y * 0) := h_mul y y (b - a) 0 h_refl_y h_symm_h0
      have h1 : y * (b - a) = x := by
        dsimp [y]
        field_simp [hd]
      have h2 : y * 0 = 0 := by ring
      rw [h1, h2] at h_mul1
      exact h_symm x 0 h_mul1
    -- Step 3: R is full
    left
    intro u v
    have h0u : R 0 u := h0x u
    have h0v : R 0 v := h0x v
    exact h_trans u 0 v (h_symm 0 u h0u) h0v
  · right
    intro x y
    constructor
    · intro hR
      by_contra hne
      exact h ⟨x, y, hne, hR⟩
    · intro hxy
      rw [hxy]
      exact h_refl y