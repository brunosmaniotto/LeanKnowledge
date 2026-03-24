import Mathlib

/-- Strict convexity of preferences: if x ≿ y and x ≠ y, then (x + y)/2 ≻ y -/
theorem Claim_5e_d
    {Bundle : Type*}
    (weakPref strictPref : Bundle → Bundle → Prop)
    (avg : Bundle → Bundle → Bundle)
    (strict_convexity : ∀ x y : Bundle, weakPref x y → x ≠ y → strictPref (avg x y) y)
    (x11 x12 : Bundle)
    (h_pref : weakPref x11 x12)
    (h_neq : x11 ≠ x12) :
    strictPref (avg x11 x12) x12 :=
  strict_convexity x11 x12 h_pref h_neq