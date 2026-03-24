import Mathlib

theorem cantor_bernstein_schröder {S T : Type*} (f : S → T) (g : T → S)
    (h_f_inj : Function.Injective f) (h_g_inj : Function.Injective g) :
    ∃ h : S → T, Function.Bijective h := by
  exact?