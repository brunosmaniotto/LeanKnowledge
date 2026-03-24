import Mathlib

/-- A lump-sum tax raising the same revenue as a per-unit tax is preferred by consumers
    because it does not distort the price–quantity margin. The per-unit tax creates a
    positive deadweight loss, so consumers retain more surplus under the lump-sum scheme. -/
theorem Exercise_4_26_d
    (CS_lumpsum CS_perunit dwl : ℝ)
    -- The per-unit tax distorts the price–quantity margin, creating positive deadweight loss
    (h_dwl_pos : 0 < dwl)
    -- Equal-revenue comparison: lump-sum surplus = per-unit surplus + deadweight loss
    (h_surplus : CS_lumpsum = CS_perunit + dwl) :
    -- Consumers prefer the lump-sum tax
    CS_lumpsum > CS_perunit := by
  linarith