import Mathlib

/-- The three assumptions underlying the contingent commodity market interpretation
    of Arrow-Debreu equilibria (MWG Assumption 5.4a):
    (1) perfect monitoring — bankruptcy is ruled out,
    (2) perfect information — all agents observe the realized state,
    (3) perfect enforcement — all contracts are enforced. -/
structure ContingentCommodityAssumptions where
  /-- Perfect monitoring: no firm or consumer can misrepresent the amount
      they can supply (bankruptcy is ruled out). -/
  perfect_monitoring : Prop
  /-- Perfect information: all firms and consumers are informed of the
      realized state at each date. -/
  perfect_information : Prop
  /-- Perfect enforcement: all contracts are perfectly enforced. -/
  perfect_enforcement : Prop