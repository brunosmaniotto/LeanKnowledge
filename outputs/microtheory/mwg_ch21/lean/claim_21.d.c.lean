import Mathlib
open Topology

theorem oligarchy_quasitransitive_not_transitive :
  ∃ (R : (Fin 2 → Fin 3 → Fin 3 → Prop) → Fin 3 → Fin 3 → Prop),
    -- Quasitransitive: strict social preference is transitive
    (∀ profile : Fin 2 → Fin 3 → Fin 3 → Prop,
      (∀ i, ∀ x y z : Fin 3, profile i x y → profile i y z → profile i x z) →
      (∀ i, ∀ x : Fin 3, profile i x x) →
      (∀ i, ∀ x y : Fin 3, profile i x y ∨ profile i y x) →
      ∀ a b c : Fin 3,
        (R profile a b ∧ ¬R profile b a) →
        (R profile b c ∧ ¬R profile c b) →
        (R profile a c ∧ ¬R profile c a)) ∧
    -- Paretian
    (∀ profile : Fin 2 → Fin 3 → Fin 3 → Prop,
      ∀ a b : Fin 3,
        (∀ i : Fin 2, profile i a b ∧ ¬profile i b a) →
        (R profile a b ∧ ¬R profile b a)) ∧
    -- Not transitive: counterexample
    (∃ profile : Fin 2 → Fin 3 → Fin 3 → Prop,
      ∃ a b c : Fin 3,
        R profile a b ∧ R profile b c ∧ ¬R profile a c) := by
  -- Oligarchy rule: xRy ↔ ∀ i, profile i x y
  refine ⟨fun profile x y => ∀ i : Fin 2, profile i x y, ?_, ?_, ?_⟩
  · -- Quasitransitivity
    intro profile htrans hrefl htotal a b c ⟨hab, hnba⟩ ⟨hbc, hncb⟩
    constructor
    · intro i
      exact htrans i a b c (hab i) (hbc i)
    · intro hca
      -- ¬(∀i, p i b a), so ∃i, ¬p i b a
      apply hnba
      intro i
      -- We have p i c a (from hca) and p i a b (from hab)
      -- Wait, we need p i b a. We have total: p i b a ∨ p i a b.
      -- From ¬(∀i, p i b a), get some j with ¬p j b a.
      -- But we need ∀i, p i b a. This is tricky.
      -- Actually: from ¬∀i, p i b a we get ∃j, ¬p j b a
      -- For that j, by totality p j a b (which we already have).
      -- But we need to show ∀i, p i b a for the contradiction.
      -- Let's use a different approach: show ¬(∀i, p i c a).
      -- We know ∀i, p i a b and ∀i, p i b c.
      -- If also ∀i, p i c a, then in particular p j c a for all j.
      -- And p j a b, so p j c b by transitivity. But ¬∀i, p i c b. Contradiction!
      -- So ¬∀i, p i c a. Good, that gives the second conjunct.
      -- But we need ∀i, p i a c for the first conjunct. That's the issue above.
      -- Actually we DO have ∀i, p i a c by transitivity of individual prefs.
      -- And ¬∀i, p i c a follows from: if ∀i, p i c a, then
      --   combined with ∀i, p i a b, we get ∀i, p i c b, contradicting ¬∀i, p i c b.
      -- So the proof structure is correct but I need to prove ∀i, p i b a here.
      -- Hmm, for this branch we're trying to derive False from hca : ∀i, p i c a.
      -- We have ∀i, p i c a and ∀i, p i a b, so ∀i, p i c b by trans.
      -- But ¬∀i, p i c b. Contradiction!
      exact htrans i b c a (hbc i) (hca i)
  · -- Paretian
    intro profile a b hall
    exact ⟨fun i => (hall i).1, fun h => (hall 0).2 (h 0)⟩
  · -- Counterexample: agent 0 prefers 0>1>2, agent 1 prefers 1>0>2
    -- Social: R 0 1 needs ∀i, p i 0 1. Agent 1 has 1>0, so ¬p 1 0 1 (strictly).
    -- Actually let me use: agent 0 has 0≥1≥2, agent 1 has 1≥0≥2
    -- R 0 1 = p 0 0 1 ∧ p 1 0 1. Agent 1: 1>0, so p 1 0 1 = false. So ¬R 0 1.
    -- I need R a b ∧ R b c ∧ ¬R a c.
    -- Try: profile where not all agree on a→c.
    -- Agent 0: 0≥1≥2 (linear order), Agent 1: 2≥0≥1
    -- R 0 1: need p 0 0 1 ∧ p 1 0 1. p 0: 0≥1 yes. p 1: 0≥1 yes (2≥0≥1). Yes!
    -- R 1 2: need p 0 1 2 ∧ p 1 1 2. p 0: 1≥2 yes. p 1: 1≥2? In 2≥0≥1, is 1≥2? No!
    -- Try: Agent 0: 0≥1≥2, Agent 1: 1≥2≥0
    -- R 0 1: p 0 0 1 (yes) ∧ p 1 0 1 (in 1≥2≥0, is 0≥1? No, 1>0). Fails.
    -- Try finding profile where R a b ∧ R b c ∧ ¬R a c
    -- means ∀i, p i a b AND ∀i, p i b c AND ¬∀i, p i a c
    -- i.e., ∃j, ¬p j a c. So both agents agree a≥b and b≥c but some agent has ¬(a≥c).
    -- With transitive individual prefs this is impossible!
    -- So we need non-transitive individual preferences for the counterexample.
    -- Actually the point is: we prove quasitransitivity GIVEN transitive individuals,
    -- but show non-transitivity of R can happen with non-transitive individuals or
    -- more precisely: social INDIFFERENCE is not transitive even with transitive individuals.
    -- Non-transitivity of R (weak) can't happen with transitive individuals.
    -- The claim is about social INDIFFERENCE: a I b and b I c but not a I c.
    -- That means R a b ∧ R b a ∧ R b c ∧ R c b ∧ ¬(R a c ∧ R c a).
    -- With transitive individuals, R a c holds (all have a≥b≥c so a≥c).
    -- But ¬R c a can happen: not all have c≥a.
    -- So the social preference IS transitive (R a b ∧ R b c → R a c).
    -- The issue is indifference is not transitive. But the theorem says "not transitive"
    -- referring to the full ordering. With quasitransitivity but not full transitivity,
    -- the standard example is: a I b, b I c, but a P c.
    -- This IS consistent with R being "transitive" in the sense R a b ∧ R b c → R a c!
    -- The issue: "transitive" for a social welfare function means the weak ordering is
    -- a complete preorder (transitive and total). Quasitransitivity is weaker.
    -- Actually R a b ∧ R b c → R a c DOES hold with transitive individuals.
    -- So R IS transitive in that sense. The point is R is not a WEAK ORDER because
    -- indifference is not an equivalence relation (not transitive).
    -- For Arrow's theorem we need a "social welfare function" producing a weak order.
    -- Oligarchy produces quasitransitive but not necessarily transitive indifference.
    -- For the counterexample: 2 agents, 3 alternatives.
    -- Agent 0: 0 > 1 > 2 (strict linear order, so 0≥1≥2≥nothing back)
    -- Agent 1: 1 > 2 > 0
    -- R x y = ∀i, p i x y.
    -- R 0 1: p 0 0 1 = yes (0>1), p 1 0 1 = no (1>0). So R 0 1 = false.
    -- Hmm. Let me pick: Agent 0: 0>1>2, Agent 1: 2>0>1
    -- R 0 1: p0 yes, p1 0≥1? In 2>0>1: yes 0>1. So R 0 1 = true.
    -- R 1 0: p0 1≥0? No. p1 1≥0? No (0>1 is false, 2>0>1 means 0>1). So R 1 0 = false.
    -- R 0 2: p0 0≥2 yes. p1 0≥2? In 2>0>1: no, 2>0. So R 0 2 = false.
    -- So R 0 1 true, but I need R b c for some b,c too.
    -- R 1 2: p0 1≥2 yes. p1 1≥2? In 2>0>1: no, 2>1. R 1 2 = false.
    -- This is hard because with 2 agents, unanimity is strict.
    -- Let me use: the oligarchy is a SINGLE agent (1 oligarch). Then R = that agent's pref.
    -- That's transitive. No good.
    -- With 2 oligarchs, both must agree. Indifference = both agree on both directions.
    -- Actually, the POINT is that with all agents as oligarchs, R x y = ∀i, p i x y.
    -- Social indifference: (∀i, p i x y) ∧ (∀i, p i y x).
    -- This requires EVERYONE to be indifferent (since prefs are total).
    -- With strict linear orders, no one is indifferent, so social indifference only on x=x.
    -- The oligarchy example works with WEAK preferences that allow ties.
    -- But with weak preferences we lose totality of individual P.
    -- OK let me just go with the simplest formalization: demonstrate that R (oligarchy rule)
    -- is not transitive by using profiles WITHOUT requiring individual transitivity.
    -- The quasitransitivity is proved conditional on individual transitivity.
    -- The non-transitivity example can use any profile.
    -- Profile: agent 0 has {(0,1),(1,2)} (not transitive), agent 1 has everything.
    -- R x y = ∀i, p i x y. R 0 1 = p0(0,1)∧p1(0,1) = T∧T = T.
    -- R 1 2 = p0(1,2)∧p1(1,2) = T∧T = T. R 0 2 = p0(0,2)∧p1(0,2) = F∧T = F.
    -- So R 0 1 ∧ R 1 2 ∧ ¬R 0 2. YES!
    -- This shows R is not necessarily transitive (with arbitrary profiles).
    -- The quasitransitivity is only guaranteed with rational (transitive) individual prefs.
    use fun (i : Fin 2) (x y : Fin 3) =>
      match i.val, x.val, y.val with
      | 0, 0, 1 => True
      | 0, 1, 2 => True
      | 0, 0, 0 => True
      | 0, 1, 1 => True
      | 0, 2, 2 => True
      | 1, _, _ => True
      | _, _, _ => False
    refine ⟨0, 1, 2, ?_, ?_, ?_⟩
    · intro i; fin_cases i <;> simp
    · intro i; fin_cases i <;> simp
    · simp only [not_forall]
      exact ⟨0, by simp⟩