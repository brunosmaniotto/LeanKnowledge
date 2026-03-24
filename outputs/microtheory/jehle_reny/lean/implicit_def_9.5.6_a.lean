import Mathlib
open Topology

/-- The individual rationality (outside option) function for a mechanism.
    For each player `i` and type `t_i ∈ T i`, `IR i t_i` gives `i`'s expected utility
    from non-participation when their type is `t_i`. -/
abbrev IROutsideOption (I : Type*) (T : I → Type*) := ∀ i, T i → ℝ

/-- Seller-buyer outside options (MWG 9.5.6):
    Seller (player 0): IR(v_s) = v_s; Buyer (player 1): IR(v_b) = 0. -/
noncomputable def sellerBuyerIR : IROutsideOption (Fin 2) (fun _ => ℝ) := fun i v =>
  if i = 0 then v else 0