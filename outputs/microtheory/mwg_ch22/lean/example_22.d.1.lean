import Mathlib
open BigOperators
open Topology

theorem Example_22_D_1 :
    ∃ (F : (Fin 2 → Fin 3 → ℝ) → Fin 3 → Fin 3 → Prop),
      (∀ (u : Fin 2 → Fin 3 → ℝ) (c : Fin 2 → ℝ) (x y : Fin 3),
        F (fun i a => u i a + c i) x y ↔ F u x y) ∧
      (∃ (u v : Fin 2 → Fin 3 → ℝ) (x y : Fin 3),
        (∀ i, u i x = v i x) ∧ (∀ i, u i y = v i y) ∧
        (F u x y ∧ ¬F v x y)) := by
  -- F(u)(x,y) iff Σᵢ (u(i,x) - u(i,0))² ≥ Σᵢ (u(i,y) - u(i,0))²
  refine ⟨fun u x y => ∑ i : Fin 2, (u i x - u i 0)^2 ≥ ∑ i : Fin 2, (u i y - u i 0)^2,
    ?_, ?_⟩
  · intro u c x y
    simp only [Fin.sum_univ_two]
    constructor <;> intro h <;> ring_nf at h ⊢ <;> linarith
  · -- u: agent0 → (0,4,1), agent1 → (0,1,4)
    -- v: agent0 → (3,4,1), agent1 → (3,1,4)
    -- u,v agree on alt 1 and alt 2, differ on alt 0 (= x*)
    -- F(u)(1,2): (4-0)²+(1-0)² = 17 ≥ (1-0)²+(4-0)² = 17 ✓
    -- F(v)(1,2): (4-3)²+(1-3)² = 5 ≥ (1-3)²+(4-3)² = 5 ✓ ... equal again
    -- Try asymmetric: u: (0,3,1), (0,1,2); v: (2,3,1), (2,1,2)
    -- F(u)(1,2): (3-0)²+(1-0)²=10 vs (1-0)²+(2-0)²=5 → 10≥5 ✓
    -- F(v)(1,2): (3-2)²+(1-2)²=2 vs (1-2)²+(2-2)²=1 → 2≥1 ✓ still same
    -- Need F(u)(x,y) but ¬F(v)(x,y). Try: u: (0,2,3), (0,3,1); v: (1,2,3),(1,3,1)
    -- F(u)(1,2): (2)²+(3)²=13 vs (3)²+(1)²=10 → 13≥10 ✓
    -- F(v)(1,2): (1)²+(2)²=5 vs (2)²+(0)²=4 → 5≥4 ✓
    -- Try: u: (0,1,2),(0,2,1); v: (10,1,2),(10,2,1)
    -- F(u)(1,2): 1+4=5 vs 4+1=5 → 5≥5 ✓
    -- F(v)(1,2): 81+64=145 vs 64+81=145 → tied. Same by symmetry!
    -- Break symmetry: u: (0,1,3),(0,4,1); v: (2,1,3),(2,4,1)
    -- F(u)(1,2): 1+16=17 vs 9+1=10 → ✓
    -- F(v)(1,2): 1+4=5 vs 1+1=2 → ✓
    -- u:(0,1,0),(0,0,2); v:(1,1,0),(1,0,2)
    -- F(u)(1,2): 1+0=1 vs 0+4=4 → 1≥4 ✗! Good, ¬F(u)(1,2)
    -- F(v)(1,2): 0+1=1 vs 1+1=2 → 1≥2 ✗. Same direction.
    -- u:(0,2,1),(0,0,3); v:(5,2,1),(5,0,3)
    -- F(u)(1,2): 4+0=4 vs 1+9=10 → ✗
    -- F(v)(1,2): 9+25=34 vs 16+4=20 → ✓! Reversed!
    -- So F(v)(1,2) holds but ¬F(u)(1,2). Use x=1,y=2, swap u↔v.
    refine ⟨![fun a => ![5,2,1] a, fun a => ![5,0,3] a],
            ![fun a => ![0,2,1] a, fun a => ![0,0,3] a],
            1, 2, ?_, ?_, ?_, ?_⟩
    · intro i; fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]
    · intro i; fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]
    · simp [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]
      norm_num
    · simp [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]
      norm_num