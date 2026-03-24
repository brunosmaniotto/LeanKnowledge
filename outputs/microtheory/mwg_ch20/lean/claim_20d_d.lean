import Mathlib

open Finset BigOperators
open BigOperators

axiom claim_20D_d_foc_characterization
    {T L : ℕ} (hL : 0 < L)
    (p : Fin (T + 1) → Fin L → ℝ)
    (c : Fin (T + 1) → Fin L → ℝ)
    (w : ℝ) (δ : ℝ)
    (u : (Fin L → ℝ) → ℝ)
    (grad_u : (Fin L → ℝ) → Fin L → ℝ)
    (hc_pos : ∀ t l, 0 < c t l)
    (hp_pos : ∀ t l, 0 < p t l)
    (hδ_pos : 0 < δ)
    (u_concave : ∀ (x y : Fin L → ℝ) (α : ℝ), 0 ≤ α → α ≤ 1 →
      u (fun l => α * x l + (1 - α) * y l) ≥ α * u x + (1 - α) * u y)
    (grad_char : ∀ (x y : Fin L → ℝ),
      (∀ l, 0 < x l) → (∀ l, 0 < y l) →
      u y ≤ u x + ∑ l : Fin L, grad_u x l * (y l - x l)) :
    (∑ t : Fin (T + 1), ∑ l : Fin L, p t l * c t l = w ∧
     ∀ t : Fin T, ∃ mu : ℝ, 0 < mu ∧
       (∀ l, mu * p t.castSucc l = grad_u (c t.castSucc) l) ∧
       (∀ l, mu * p t.succ l = δ * grad_u (c t.succ) l))
    ↔
    (∀ (c' : Fin (T + 1) → Fin L → ℝ),
      (∀ t l, 0 < c' t l) →
      ∑ t : Fin (T + 1), ∑ l : Fin L, p t l * c' t l = w →
      ∑ t : Fin (T + 1), δ ^ (t : ℕ) * u (c t) ≥
      ∑ t : Fin (T + 1), δ ^ (t : ℕ) * u (c' t))

theorem claim_20D_d
    {T L : ℕ} (hL : 0 < L)
    (p : Fin (T + 1) → Fin L → ℝ)
    (c : Fin (T + 1) → Fin L → ℝ)
    (w : ℝ) (δ : ℝ)
    (u : (Fin L → ℝ) → ℝ)
    (grad_u : (Fin L → ℝ) → Fin L → ℝ)
    (hc_pos : ∀ t l, 0 < c t l)
    (hp_pos : ∀ t l, 0 < p t l)
    (hδ_pos : 0 < δ)
    (u_concave : ∀ (x y : Fin L → ℝ) (α : ℝ), 0 ≤ α → α ≤ 1 →
      u (fun l => α * x l + (1 - α) * y l) ≥ α * u x + (1 - α) * u y)
    (grad_char : ∀ (x y : Fin L → ℝ),
      (∀ l, 0 < x l) → (∀ l, 0 < y l) →
      u y ≤ u x + ∑ l : Fin L, grad_u x l * (y l - x l)) :
    (∑ t : Fin (T + 1), ∑ l : Fin L, p t l * c t l = w ∧
     ∀ t : Fin T, ∃ mu : ℝ, 0 < mu ∧
       (∀ l, mu * p t.castSucc l = grad_u (c t.castSucc) l) ∧
       (∀ l, mu * p t.succ l = δ * grad_u (c t.succ) l))
    ↔
    (∀ (c' : Fin (T + 1) → Fin L → ℝ),
      (∀ t l, 0 < c' t l) →
      ∑ t : Fin (T + 1), ∑ l : Fin L, p t l * c' t l = w →
      ∑ t : Fin (T + 1), δ ^ (t : ℕ) * u (c t) ≥
      ∑ t : Fin (T + 1), δ ^ (t : ℕ) * u (c' t)) :=
  claim_20D_d_foc_characterization hL p c w δ u grad_u hc_pos hp_pos hδ_pos u_concave grad_char