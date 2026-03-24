import Mathlib

variable (S : Type) [Semigroup S] [Fintype S] [Nonempty S] [IsCancelMul S]

-- The theorem we want is exactly provided by Mathlib as: