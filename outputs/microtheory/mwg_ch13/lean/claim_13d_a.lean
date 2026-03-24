import Mathlib
open Topology

-- Screening model: two worker types, education cost, wages
structure ScreeningModel where
  θ_H : ℝ  -- high type productivity
  θ_L : ℝ  -- low type productivity
  h_pos_H : 0 < θ_H
  h_pos_L : 0 < θ_L
  h_types : θ_L < θ_H

-- A contract specifies (wage, education level)
structure Contract where
  wage : ℝ
  education : ℝ

-- Worker utility: wage - cost of education (cost depends on type)
-- Under complete info: (θ_H, 0) means wage = θ_H, education = 0
-- Under complete info: (θ_L, 0) means wage = θ_L, education = 0

-- Low-type worker utility from a contract (education cost = e/θ_L, but at e=0 it's just wage)
noncomputable def utility_low (c : Contract) : ℝ := c.wage - c.education

theorem complete_info_not_sustainable (M : ScreeningModel) :
    let contract_H : Contract := ⟨M.θ_H, 0⟩
    let contract_L : Contract := ⟨M.θ_L, 0⟩
    utility_low contract_H > utility_low contract_L := by
  simp [utility_low]
  linarith [M.h_types]