import Mathlib

open Finset BigOperators
open BigOperators

theorem Claim_5F_d :
    ∃ (Y : Set (Fin 2 → ℝ)) (y : Fin 2 → ℝ),
      y ∈ Y ∧
      (∀ y' ∈ Y, (∀ i, y i ≤ y' i) → y' = y) ∧
      ¬ ∃ (p : Fin 2 → ℝ), (∀ i, 0 < p i) ∧ (∀ y' ∈ Y, ∑ i, p i * y' i ≤ ∑ i, p i * y i) := by
  -- Y = {(t, -t²) | t ∈ ℝ}, y = origin
  refine ⟨{v | ∃ t : ℝ, v 0 = t ∧ v 1 = -t ^ 2}, ![0, 0], ⟨0, by simp, by simp⟩, ?_, ?_⟩
  · -- Efficiency: if y' = (t, -t²) ≥ (0,0) then t = 0
    intro y' ⟨t, ht0, ht1⟩ hge
    have h0 := hge 0
    have h1 := hge 1
    simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons] at h0 h1
    rw [ht0] at h0; rw [ht1] at h1
    have htsq : t ^ 2 ≤ 0 := by linarith
    have hteq : t = 0 := by nlinarith [sq_nonneg t]
    ext i; fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, ht0, ht1, hteq]
  · -- No strictly positive p supports (0,0): witness t = p₀/(2p₁)
    intro ⟨p, hpos, hsup⟩
    have hp0 := hpos 0
    have hp1 := hpos 1
    -- Define witness point on the parabola
    set t₀ := p 0 / (2 * p 1)
    set w : Fin 2 → ℝ := ![t₀, -t₀ ^ 2] with hw_def
    have hmem : w ∈ {v | ∃ t : ℝ, v 0 = t ∧ v 1 = -t ^ 2} := by
      exact ⟨t₀, by simp [w, Matrix.cons_val_zero], by simp [w, Matrix.cons_val_one, Matrix.head_cons]⟩
    have hsup' := hsup w hmem
    simp [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons] at hsup'
    -- hsup' : p 0 * t₀ + p 1 * -t₀² ≤ 0
    -- i.e. p 0 * (p 0 / (2 * p 1)) - p 1 * (p 0 / (2 * p 1))² ≤ 0
    -- = p₀²/(2p₁) - p₀²/(4p₁) = p₀²/(4p₁) ≤ 0, contradiction
    have hp1_ne : p 1 ≠ 0 := ne_of_gt hp1
    have h2p1_ne : 2 * p 1 ≠ 0 := by positivity
    have h2p1_pos : (0 : ℝ) < 2 * p 1 := by positivity
    -- Multiply through by 4 * p 1 ^ 2 > 0 to clear denominators
    have key : p 0 * t₀ + p 1 * (-t₀ ^ 2) ≤ 0 := hsup'
    -- Expand t₀ and clear fractions
    have expand : p 0 * t₀ + p 1 * (-t₀ ^ 2) = p 0 ^ 2 / (4 * p 1) := by
      simp only [t₀]
      field_simp
      ring
    rw [expand] at key
    have : 0 < p 0 ^ 2 / (4 * p 1) := by positivity
    linarith