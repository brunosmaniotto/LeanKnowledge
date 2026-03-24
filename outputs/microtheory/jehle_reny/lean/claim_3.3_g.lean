import Mathlib

open Set

theorem longRun_cost_le_shortRun_cost
    {X : Type*}
    (cost : X → ℝ)
    (feasLR : Set X)
    (feasSR : Set X)
    (h_sub : feasSR ⊆ feasLR)
    (h_bdd : BddBelow (cost '' feasLR))
    (h_ne : (cost '' feasSR).Nonempty) :
    sInf (cost '' feasLR) ≤ sInf (cost '' feasSR) := by
  apply csInf_le_csInf h_bdd h_ne
  exact image_mono h_sub