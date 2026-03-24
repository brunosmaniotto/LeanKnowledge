import Mathlib
open BigOperators
open Topology

/-- Claim 5G(c): Under uncertainty, owners with different risk attitudes
    disagree on production plan rankings, so unanimity for profit maximization
    breaks down. We exhibit two owners who rank two plans differently. -/
theorem Claim_5G_c :
    ∃ (u₁ u₂ : ℝ → ℝ) (π : Fin 2 → ℝ) (y₁ y₂ : Fin 2 → ℝ),
      (∀ s, 0 ≤ π s) ∧
      (∑ s : Fin 2, π s) = 1 ∧
      -- Owner 1 prefers plan y₁ over y₂
      (∑ s : Fin 2, π s * u₁ (y₁ s)) > (∑ s : Fin 2, π s * u₁ (y₂ s)) ∧
      -- Owner 2 prefers plan y₂ over y₁
      (∑ s : Fin 2, π s * u₂ (y₂ s)) > (∑ s : Fin 2, π s * u₂ (y₁ s)) := by
  -- Owner 1: concave (sqrt-like via negation of square deviation), Owner 2: convex (x^2)
  -- Plan y₁ = (2, 2) safe, Plan y₂ = (4, 0) risky, equal probs
  -- u₁(x) = -x^2 + 8x (concave): EU(y₁) = 1/2*12 + 1/2*12 = 12, EU(y₂) = 1/2*0 + 1/2*0 = 0... let me just use concrete numbers
  -- u₁(x) = x (linear, but slightly concave won't work). Let me use:
  -- u₁ = sqrt won't compute. Use: u₁(x) = -(x-3)^2, u₂(x) = x^2
  -- y₁ = (3,3), y₂ = (5,1), π = (1/2, 1/2)
  -- u₁: EU(y₁) = 1/2*0 + 1/2*0 = 0, EU(y₂) = 1/2*(-4) + 1/2*(-4) = -4. Owner 1 prefers y₁. ✓
  -- u₂: EU(y₁) = 1/2*9 + 1/2*9 = 9, EU(y₂) = 1/2*25 + 1/2*1 = 13. Owner 2 prefers y₂. ✓
  refine ⟨fun x => -(x - 3) ^ 2, fun x => x ^ 2,
          ![1/2, 1/2], ![3, 3], ![5, 1], ?_, ?_, ?_, ?_⟩
  · intro s; fin_cases s <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one] <;> norm_num
  · simp [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one]; ring
  · simp [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one]; ring_nf; norm_num
  · simp [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one]; ring_nf; norm_num