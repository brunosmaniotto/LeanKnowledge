import Mathlib

open BigOperators

/-- Strict monotonicity implies the budget constraint binds at the optimum: p · x* = y. -/
theorem Claim_1_3_e
    {L : ℕ} (hL : 0 < L)
    (p : Fin L → ℝ) (y : ℝ)
    (hp : ∀ i, 0 < p i)
    (u : (Fin L → ℝ) → ℝ)
    (x_star : Fin L → ℝ)
    (h_budget : ∑ i : Fin L, p i * x_star i ≤ y)
    (h_opt : ∀ x : Fin L → ℝ, ∑ i : Fin L, p i * x i ≤ y → u x ≤ u x_star)
    (h_mono : ∀ x x' : Fin L → ℝ, (∀ i, x i < x' i) → u x < u x') :
    ∑ i : Fin L, p i * x_star i = y := by
  by_contra hne
  have hlt : ∑ i : Fin L, p i * x_star i < y := lt_of_le_of_ne h_budget hne
  have hsp : (0 : ℝ) < ∑ i : Fin L, p i :=
    Finset.sum_pos (fun i _ => hp i) ⟨⟨0, hL⟩, Finset.mem_univ _⟩
  set δ := (y - ∑ i : Fin L, p i * x_star i) / ∑ i : Fin L, p i with hδ_def
  have hδ : 0 < δ := div_pos (by linarith) hsp
  have hpref : u x_star < u (fun i => x_star i + δ) :=
    h_mono _ _ fun i => by linarith [hδ]
  have hcost : ∑ i : Fin L, p i * (x_star i + δ) ≤ y := by
    simp only [mul_add, Finset.sum_add_distrib]
    suffices ∑ i : Fin L, p i * δ = y - ∑ i : Fin L, p i * x_star i by linarith
    have h1 : ∑ i : Fin L, p i * δ = δ * ∑ i : Fin L, p i := by
      rw [← Finset.sum_mul, mul_comm]
    rw [h1, hδ_def]
    field_simp
  linarith [h_opt (fun i => x_star i + δ) hcost]