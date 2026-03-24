import Mathlib
open Topology

/-- Price tâtonnement dynamics (Samuelson's differential equation version).
    Given `L` goods, excess demand `z`, and adjustment speeds `c` (all positive),
    the dynamics are dp_ℓ/dt = c_ℓ · z_ℓ(p) for each good ℓ. -/
noncomputable def priceTatonnementDynamics
    (L : ℕ)
    (c : Fin L → ℝ)
    (z : (Fin L → ℝ) → Fin L → ℝ)
    (p : Fin L → ℝ) : Fin L → ℝ :=
  fun ℓ => c ℓ * z p ℓ