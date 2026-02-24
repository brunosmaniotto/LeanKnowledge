import Mathlib.Topology.Basic
import Mathlib.Topology.Instances.Real
import Mathlib.Data.Real.Basic
import Mathlib.Order.Basic

open Set Filter Topology

variable {L : ℕ} [NeZero L]

/-- The diagonal ray vector e = (1, 1, ..., 1) -/
def e : Fin L → ℝ := fun _ ↦ 1

/-- The mapping from scalars to the diagonal ray -/
def ray (t : ℝ) : Fin L → ℝ := t • e

/-- 
Lemma A: For any bundle x, the sets of scalars {t | ray t ≽ x} and {t | x ≽ ray t} 
are closed (by continuity of preferences) and non-empty (by monotonicity and Archimedean property).
-/
theorem ray_contour_properties 
    (R : (Fin L → ℝ) → (Fin L → ℝ) → Prop)
    (h_cont : (∀ y, IsClosed {x | R x y}) ∧ (∀ y, IsClosed {x | R y x}))
    (h_mono : ∀ x y, (∀ i, x i ≤ y i) ∧ (x ≠ y) → R y x ∧ ¬ R x y) 
    (x : Fin L → ℝ) :
    let S_upper := {t : ℝ | R (ray t) x}
    let S_lower := {t : ℝ | R x (ray t)}
    IsClosed S_upper ∧ IsClosed S_lower ∧ S_upper.Nonempty ∧ S_lower.Nonempty := by
  
  let S_upper := {t : ℝ | R (ray t) x}
  let S_lower := {t : ℝ | R x (ray t)}

  -- 1. Closedness follows from continuity of ray map and R
  have h_ray_cont : Continuous ray := continuous_id.smul continuous_const
  
  have h_closed_upper : IsClosed S_upper := 
    IsClosed.preimage h_ray_cont (h_cont.1 x)
    
  have h_closed_lower : IsClosed S_lower := 
    IsClosed.preimage h_ray_cont (h_cont.2 x)

  -- 2. Non-emptiness follows from monotonicity bounds
  -- Upper bound: pick t big enough so ray t > x everywhere
  have h_nonempty_upper : S_upper.Nonempty := by
    -- Let t_high = max(x_i) + 1
    let t_high := (Finset.univ.image x).max' (Finset.univ_nonempty) + 1
    use t_high
    -- Show ray t_high > x
    have h_strict : ∀ i, x i ≤ (ray t_high) i := by
      intro i
      dsimp [ray, e]
      simp
      -- x i ≤ max x < max x + 1
      apply le_trans (Finset.le_max' (Finset.univ.image x) (x i) (Finset.mem_image_of_mem _ (Finset.mem_univ _)))
      linarith
    -- ray t_high ≠ x because ray t_high is strictly greater
    have h_ne : ray t_high ≠ x := by
      intro h
      have h0 := h_strict 0 -- use arbitrary index
      rw [h] at h0
      linarith
    
    have h_pref := h_mono x (ray t_high) ⟨h_strict, h_ne.symm⟩
    exact h_pref.1

  -- Lower bound: pick t small enough so ray t < x everywhere
  have h_nonempty_lower : S_lower.Nonempty := by
    -- Let t_low = min(x_i) - 1
    let t_low := (Finset.univ.image x).min' (Finset.univ_nonempty) - 1
    use t_low
    have h_strict : ∀ i, (ray t_low) i ≤ x i := by
      intro i
      dsimp [ray, e]
      simp
      apply le_trans _ (Finset.min'_le (Finset.univ.image x) (x i) (Finset.mem_image_of_mem _ (Finset.mem_univ _)))
      linarith
    have h_ne : ray t_low ≠ x := by
      intro h
      have h0 := h_strict 0
      rw [h] at h0
      linarith
      
    have h_pref := h_mono (ray t_low) x ⟨h_strict, h_ne⟩
    exact h_pref.1

  exact ⟨h_closed_upper, h_closed_lower, h_nonempty_upper, h_nonempty_lower⟩
