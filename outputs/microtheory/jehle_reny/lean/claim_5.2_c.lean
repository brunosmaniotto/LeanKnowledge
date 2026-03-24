import Mathlib

theorem Claim_5_2_c
    (β w T π_val p : ℝ)
    (hw : w ≠ 0) (hp : p ≠ 0)
    (hβ : 0 < β) (hβ1 : β < 1) :
    let I := w * T + π_val
    let hc := (1 - β) * I / w
    let yc := β * I / p
    p * yc + w * hc = I := by
  simp only
  field_simp
  ring