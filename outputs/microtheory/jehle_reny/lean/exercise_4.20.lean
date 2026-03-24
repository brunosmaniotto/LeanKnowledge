import Mathlib

/-- Compensating variation for demand x(p,y) = y/p with y=7, price change p=1 to p=4.
    CV = e(p₁, u⁰) − y where u⁰ = v(p⁰, y) = y/p⁰ and e(p, u) = p·u.
    CV = 4 * (7/1) − 7 = 21. -/
theorem Exercise_4_20 : (4 : ℝ) * ((7 : ℝ) / 1) - 7 = 21 := by norm_num