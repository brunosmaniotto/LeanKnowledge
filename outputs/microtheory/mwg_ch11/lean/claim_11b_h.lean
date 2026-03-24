import Mathlib
open Topology

variable {α : Type} [CommRing α] {φ₁ : α → α}
variable {h hstar s_h t_h : α}

theorem Claim_11B_h (h_eq : s_h = t_h) :
    φ₁ h + s_h * (hstar - h) = φ₁ h - t_h * h + t_h * hstar := by
  rw [h_eq]
  ring