import Mathlib
open Topology

structure FirstBestContract where
  w_H : ℝ
  w_L : ℝ
  e_H : ℝ
  e_L : ℝ
  θ_H : ℝ
  θ_L : ℝ
  θ_H_lt_θ_L : θ_H < θ_L
  e_L_pos : 0 < e_L
  e_H_gt_e_L : e_H > e_L
  participation_eq : w_H - θ_H * e_H = w_L - θ_L * e_L

noncomputable def managerUtility (w e θ : ℝ) : ℝ := w - θ * e

theorem claim_14C_d (C : FirstBestContract) :
    managerUtility C.w_L C.e_L C.θ_H > managerUtility C.w_H C.e_H C.θ_H := by
  unfold managerUtility
  have h := C.participation_eq
  have h1 : C.θ_H < C.θ_L := C.θ_H_lt_θ_L
  have h2 : 0 < C.e_L := C.e_L_pos
  nlinarith