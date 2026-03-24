import Mathlib

/-- The equally distributed equivalent income. An income level `ye` is the equally
    distributed equivalent for welfare function `W` and distribution `y` if giving
    every individual `ye` produces the same social welfare: W(ye, …, ye) = W(y).
    (Atkinson, 1970; MWG Exercise 6.14) -/
def IsEquallyDistributedEquivalent {N : ℕ} (W : (Fin N → ℝ) → ℝ)
    (y : Fin N → ℝ) (ye : ℝ) : Prop :=
  W (fun _ => ye) = W y