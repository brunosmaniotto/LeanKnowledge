import Mathlib

universe u

/-
Definition (Definition_11.B.1): An externality is present whenever the well-being of a consumer
or the production possibilities of a firm are directly affected by the actions of another agent in the economy.
'Directly' means excluding effects mediated by prices (pecuniary externalities).

Context: Foundational definition for the theory of externalities. Pecuniary externalities
(effects through prices) are excluded and create no inefficiency under price-taking behavior.
-/

-- A type representing an economic agent.
-- This could be an individual, a company, a government, etc.
variable (Agent : Type u)

-- A predicate indicating that an agent is a consumer.
-- In a more developed model, this could be a type class or a subtype.
def IsConsumer (a : Agent) : Prop := True

-- A predicate indicating that an agent is a firm.
-- In a more developed model, this could be a type class or a subtype.