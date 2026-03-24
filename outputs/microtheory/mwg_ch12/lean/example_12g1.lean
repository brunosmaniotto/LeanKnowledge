import Mathlib

theorem Example_12G1
    (db₂_dq₁_cournot : ℝ) (db₁_dk_cournot : ℝ)
    (h_sub : db₂_dq₁_cournot < 0) (h_agg1 : db₁_dk_cournot > 0)
    (db₂_dp₁_bertrand : ℝ) (db₁_dk_bertrand : ℝ)
    (h_comp : db₂_dp₁_bertrand > 0) (h_agg2 : db₁_dk_bertrand > 0) :
    db₂_dq₁_cournot * db₁_dk_cournot < 0 ∧
    0 < db₂_dp₁_bertrand * db₁_dk_bertrand := by
  exact ⟨mul_neg_of_neg_of_pos h_sub h_agg1, mul_pos h_comp h_agg2⟩