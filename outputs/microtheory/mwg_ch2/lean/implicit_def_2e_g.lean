import Mathlib

/-- Good `l` is a **Giffen good** at `(p, w)` when increasing its own price increases
    its demand: `∂x_l(p, w)/∂p_l > 0`.

    We model this as the derivative of the map `t ↦ x(p[l ↦ t], w) l` being
    strictly positive at `p l`, where `p[l ↦ t]` updates only the `l`-th
    component of the price vector. -/
def IsGiffenGood {L : ℕ}
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (l : Fin L) (p : Fin L → ℝ) (w : ℝ) : Prop :=
  0 < deriv (fun t => x (Function.update p l t) w l) (p l)