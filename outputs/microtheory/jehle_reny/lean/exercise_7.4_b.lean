import Mathlib
open Topology

theorem Exercise_7_4_b :
    -- Player 2's payoffs: (row = U/D, col = L/M/R)
    let p2 : Fin 2 → Fin 3 → ℚ := ![![0, -3, -4], ![4, 5, 8]]
    -- L does not strictly dominate M (check row D: p2(D,L)=4 ≤ p2(D,M)=5)
    ¬(∀ i : Fin 2, p2 i 0 > p2 i 1) ∧
    -- R does not strictly dominate M (check row U: p2(U,R)=-4 ≤ p2(U,M)=-3)
    ¬(∀ i : Fin 2, p2 i 2 > p2 i 1) ∧
    -- Mixed strategy (1/2 L + 1/2 R) strictly dominates M
    (∀ i : Fin 2, (1/2 : ℚ) * p2 i 0 + (1/2 : ℚ) * p2 i 2 > p2 i 1) := by
  refine ⟨?_, ?_, ?_⟩
  · intro h
    have := h 1
    simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.head_cons] at this
    norm_num at this
  · intro h
    have := h 0
    simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.head_cons] at this
    norm_num at this
  · intro i
    fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.head_cons] <;> norm_num