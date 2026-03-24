import Mathlib

open SimpleGraph
open Finset

def K (n : ℕ) : SimpleGraph (Fin n) := completeGraph (Fin n)