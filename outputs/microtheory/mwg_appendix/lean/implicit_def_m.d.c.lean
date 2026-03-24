import Mathlib
open Matrix

namespace MWG

def submatrixRows {T S : ℕ} (t : ℕ) (ht : t ≤ T) (M : Matrix (Fin T) (Fin S) ℝ) :
    Matrix (Fin t) (Fin S) ℝ := M.submatrix (Fin.castLE ht) id