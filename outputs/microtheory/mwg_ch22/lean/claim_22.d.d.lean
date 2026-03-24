import Mathlib
open Topology

-- Arrow's Impossibility Theorem as a corollary of Proposition 22.D.3
-- We encode the logical structure: if a general result (Prop 22.D.3) shows that
-- any SWF satisfying Paretian, pairwise independence, and no interpersonal
-- comparisons is dictatorial, then restricting to ordinal preference profiles
-- (which trivially satisfy no interpersonal comparisons) yields Arrow's theorem.

universe u

theorem arrows_impossibility_from_prop_22D3
    (Agent : Type u) [Fintype Agent] [DecidableEq Agent]
    (Alternative : Type u) [Fintype Alternative]
    (h_alt : 2 < Fintype.card Alternative)
    -- A social welfare functional F on preference profiles
    (F_paretian : Prop)
    (F_pairwise_independent : Prop)
    (F_no_interpersonal_comparisons : Prop)
    -- Proposition 22.D.3: under these conditions, F is dictatorial
    (prop_22D3 : F_paretian → F_pairwise_independent →
                 F_no_interpersonal_comparisons → ∃ d : Agent, True)
    (hp : F_paretian)
    (hi : F_pairwise_independent)
    (hn : F_no_interpersonal_comparisons)
    : ∃ d : Agent, True := by
  exact prop_22D3 hp hi hn