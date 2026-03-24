import Mathlib

/-- Shapley value cost allocation for a 3-player cooperative game with given coalition costs.
    Total airfare $1600, with C(B)=C(S)=C(G)=800, C(BS)=C(BG)=1000, C(SG)=1400.
    The Shapley value gives c_B = 400, c_S = c_G = 600. -/
theorem Example_22_F_1 :
    let C_B := (800 : ℚ)
    let C_S := (800 : ℚ)
    let C_G := (800 : ℚ)
    let C_BS := (1000 : ℚ)
    let C_BG := (1000 : ℚ)
    let C_SG := (1400 : ℚ)
    let C_BSG := (1600 : ℚ)
    -- Shapley value: average marginal contribution over all 6 permutations
    let shapley_B := (1 / 6 : ℚ) * (
      (C_B) +                    -- B first: C(B) - C(∅)
      (C_B) +                    -- B first (other order): same
      (C_BS - C_S) +             -- S first, then B: C(BS) - C(S)
      (C_BG - C_G) +             -- G first, then B: C(BG) - C(G)
      (C_BSG - C_SG) +           -- S,G first, then B: C(BSG) - C(SG)
      (C_BSG - C_SG))            -- G,S first, then B: C(BSG) - C(SG)
    let shapley_S := (1 / 6 : ℚ) * (
      (C_S) +                    -- S first
      (C_S) +                    -- S first (other order)
      (C_BS - C_B) +             -- B first, then S
      (C_SG - C_G) +             -- G first, then S
      (C_BSG - C_BG) +           -- B,G first, then S
      (C_BSG - C_BG))            -- G,B first, then S
    let shapley_G := (1 / 6 : ℚ) * (
      (C_G) +                    -- G first
      (C_G) +                    -- G first (other order)
      (C_BG - C_B) +             -- B first, then G
      (C_SG - C_S) +             -- S first, then G
      (C_BSG - C_BS) +           -- B,S first, then G
      (C_BSG - C_BS))            -- S,B first, then G
    shapley_B = 400 ∧ shapley_S = 600 ∧ shapley_G = 600 := by
  norm_num