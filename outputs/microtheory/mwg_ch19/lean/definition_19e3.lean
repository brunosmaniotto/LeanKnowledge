import Mathlib

noncomputable def IsCompleteAssetStructure
    {S K : ℕ} (R : Matrix (Fin S) (Fin K) ℝ) : Prop :=
  R.rank = S