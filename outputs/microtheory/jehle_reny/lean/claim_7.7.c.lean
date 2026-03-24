import Mathlib
open Topology

/-- In the sophisticated matching pennies game, the indifference conditions
    v_3(H|I_3β) = v_3(T|I_3β), v_3(H|I_3γ) = v_3(T|I_3γ),
    v_1(H|I_1) = v_1(T|I_1), v_2(H|I_2) = v_2(T|I_2)
    force x = y = z_β = z_γ = 1/2. -/
theorem Claim_7_7_c
    (x y z_β z_γ : ℝ)
    -- Player 3's indifference at I_3β: v_3(H|I_3β) = x·(-1)+(1-x)·1 = 1-2x
    --                                   v_3(T|I_3β) = x·1+(1-x)·(-1) = 2x-1
    (h3β : 1 - 2 * x = 2 * x - 1)
    -- Player 3's indifference at I_3γ (symmetric in y)
    (h3γ : 1 - 2 * y = 2 * y - 1)
    -- Player 1's indifference at I_1: v_1(H|I_1) = 2z_β - 1, v_1(T|I_1) = 1 - 2z_β
    (h1 : 2 * z_β - 1 = 1 - 2 * z_β)
    -- Player 2's indifference at I_2 (symmetric in z_γ)
    (h2 : 2 * z_γ - 1 = 1 - 2 * z_γ) :
    x = 1 / 2 ∧ y = 1 / 2 ∧ z_β = 1 / 2 ∧ z_γ = 1 / 2 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> linarith