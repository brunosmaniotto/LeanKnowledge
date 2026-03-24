import Mathlib

open Set Topology
open Topology

theorem claim_A1_3_e (a b : ℝ) (hab : a < b) : ¬IsCompact (Set.Ioo a b) := by
  intro h
  have hclosed := h.isClosed
  have hcl : closure (Set.Ioo a b) = Set.Ioo a b := hclosed.closure_eq
  rw [closure_Ioo (ne_of_lt hab)] at hcl
  have ha : a ∈ Set.Icc a b := ⟨le_refl a, le_of_lt hab⟩
  rw [hcl] at ha
  exact lt_irrefl a ha.1