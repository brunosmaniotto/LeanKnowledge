import Mathlib
open Topology

-- Model the economic primitives
variable {n : ℕ} -- number of consumers

-- Price vector and wealth are real-valued
def PriceVec := Fin n → ℝ