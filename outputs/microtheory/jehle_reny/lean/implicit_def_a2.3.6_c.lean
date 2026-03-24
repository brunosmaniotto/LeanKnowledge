import Mathlib
open BigOperators
open Topology
namespace MWG

def CQ_I {n b : ℕ} (g : Fin b → (Fin n → ℝ)) : Prop :=
  LinearIndependent ℝ g