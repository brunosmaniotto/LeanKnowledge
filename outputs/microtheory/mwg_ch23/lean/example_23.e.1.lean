import Mathlib

theorem Example_23_E_1
    (θ_L θ_H c : ℝ)
    (hθL_pos : 0 < θ_L)
    (hθH_gt : θ_H > 2 * θ_L)
    (hc_lo : c > 2 * θ_L)
    (hc_hi : c < θ_H)
    -- transfers for agent 1 and 2 in the (θ_H, θ_H) and (θ_L, θ_H) profiles
    (t1_HH t2_HH t1_LH t2_LH : ℝ)
    -- ex post participation: t_i(θ_L, θ_H) ≥ -θ_L
    (hpart1 : t1_LH ≥ -θ_L)
    (hpart2 : t2_LH ≥ -θ_L)
    -- IC: t_i(θ_H, θ_H) ≥ t_i(θ_L, θ_H)
    (hic1 : t1_HH ≥ t1_LH)
    (hic2 : t2_HH ≥ t2_LH)
    -- feasibility: t₁(θ_H, θ_H) + t₂(θ_H, θ_H) ≤ -c
    (hfeas : t1_HH + t2_HH ≤ -c) :
    False := by
  linarith