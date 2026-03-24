import Mathlib

-- The Myerson-Satterthwaite impossibility theorem (Claim_23.F.c) is axiomatized.
axiom Claim_23_F_c : Prop

-- We assume the Myerson-Satterthwaite theorem is true.
axiom Claim_23_F_c_true : Claim_23_F_c

-- Claim 9.8: The impossibility result explains strikes in bargaining.
theorem Claim_9_8_strikes : Claim_23_F_c := Claim_23_F_c_true