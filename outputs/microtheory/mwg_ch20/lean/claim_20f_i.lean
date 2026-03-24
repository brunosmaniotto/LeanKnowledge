import Mathlib
open Topology

axiom ProductionFunction : Type
axiom F : ProductionFunction → (ℝ → ℝ)
axiom F_deriv_strictAnti : ∀ (pf : ProductionFunction),
  StrictAntiOn (deriv (F pf)) (Set.Ioi 0)

theorem modified_golden_rule_unique_and_convergence
    (pf : ProductionFunction) (δ : ℝ) (hδ_pos : 0 < δ) (hδ_lt : δ < 1)
    (k_star : ℝ) (hk_pos : 0 < k_star)
    (hk_char : deriv (F pf) k_star = 1 / δ)
    (w : ℝ → ℝ) (hw_mono : StrictMono w)
    (hw_fixed : w k_star = k_star)
    (hw_below : ∀ k, 0 < k → k < k_star → k < w k)
    (hw_upper : ∀ k, 0 < k → k < k_star → w k < k_star) :
    (∀ k : ℝ, 0 < k → deriv (F pf) k = 1 / δ → k = k_star) ∧
    (∀ k₀ : ℝ, 0 < k₀ → k₀ < k_star →
      ∀ n : ℕ, w^[n] k₀ ≤ w^[n.succ] k₀) := by
  have iter_pos : ∀ k₀, 0 < k₀ → k₀ < k_star → ∀ n, 0 < w^[n] k₀ ∧ w^[n] k₀ < k_star := by
    intro k₀ hk₀_pos hk₀_lt n
    induction n with
    | zero => simp [hk₀_pos, hk₀_lt]
    | succ n ih =>
      simp only [Function.iterate_succ', Function.comp]
      exact ⟨lt_trans ih.1 (hw_below _ ih.1 ih.2), hw_upper _ ih.1 ih.2⟩
  constructor
  · intro k hk hk_eq
    by_contra h
    have hanti := F_deriv_strictAnti pf
    rcases lt_or_gt_of_ne h with hlt | hgt
    · have := hanti (Set.mem_Ioi.mpr hk) (Set.mem_Ioi.mpr hk_pos) hlt
      linarith
    · have := hanti (Set.mem_Ioi.mpr hk_pos) (Set.mem_Ioi.mpr hk) hgt
      linarith
  · intro k₀ hk₀_pos hk₀_lt n
    induction n with
    | zero =>
      simp only [Function.iterate_zero, Function.iterate_succ', Function.comp, id]
      exact le_of_lt (hw_below k₀ hk₀_pos hk₀_lt)
    | succ n ih =>
      simp only [Function.iterate_succ', Function.comp] at ih ⊢
      have ⟨hpos_n, hlt_n⟩ := iter_pos k₀ hk₀_pos hk₀_lt n
      exact hw_mono.monotone ih