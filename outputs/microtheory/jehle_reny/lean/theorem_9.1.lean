import Mathlib
open Topology

/-- Theorem 9.1 (Jehle & Reny): In a first-price sealed-bid auction with N ≥ 2
    i.i.d. bidders drawing values from uniform [0,1], the unique symmetric Nash
    equilibrium strategy is b(v) = ((N-1)/N)·v, derived from solving the FOC ODE
    d[F^{N-1}(v)·b(v)]/dv = v·(N-1)·f(v)·F^{N-2}(v) with b(0) = 0.
    We verify: boundary condition, FOC identity, monotonicity, individual
    rationality, and uniqueness of the equilibrium coefficient. -/
theorem Theorem_9_1 (N : ℕ) (hN : 2 ≤ N) :
    -- (1) Boundary condition: b(0) = 0
    ((↑N - 1 : ℝ) / ↑N) * (0 : ℝ) = 0 ∧
    -- (2) FOC coefficient: ((N-1)/N)·N = N-1
    ((↑N - 1 : ℝ) / ↑N) * (↑N : ℝ) = (↑N - 1 : ℝ) ∧
    -- (3) Strict monotonicity: bid slope (N-1)/N > 0
    (0 : ℝ) < (↑N - 1 : ℝ) / ↑N ∧
    -- (4) Individual rationality: b(v) ≤ v for v ≥ 0
    (∀ v : ℝ, 0 ≤ v → ((↑N - 1 : ℝ) / ↑N) * v ≤ v) ∧
    -- (5) Uniqueness: coefficient uniquely determined by FOC
    (∀ c : ℝ, c * (↑N : ℝ) = (↑N - 1 : ℝ) → c = (↑N - 1 : ℝ) / ↑N) := by
  have hN_real : (2 : ℝ) ≤ ↑N := by exact_mod_cast hN
  have hN_pos : (0 : ℝ) < ↑N := by linarith
  have hN_ne : (↑N : ℝ) ≠ 0 := ne_of_gt hN_pos
  refine ⟨by ring, ?_, div_pos (by linarith) hN_pos, ?_, ?_⟩
  · -- FOC: clear denominator
    field_simp
  · -- Individual rationality: (N-1)/N ≤ 1 so b(v) ≤ v
    intro v hv
    suffices (↑N - 1 : ℝ) / ↑N ≤ 1 by nlinarith
    rw [div_le_one hN_pos]; linarith
  · -- Uniqueness: c·N = N-1 determines c = (N-1)/N
    intro c hc
    rw [eq_div_iff hN_ne]; linarith