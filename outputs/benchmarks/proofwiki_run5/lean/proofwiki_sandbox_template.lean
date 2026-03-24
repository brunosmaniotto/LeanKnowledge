import Mathlib

lemma riemann_zeta_four_exists : riemannZeta 4 = ↑Real.pi ^ 4 / 90 := by
  exact riemannZeta_four