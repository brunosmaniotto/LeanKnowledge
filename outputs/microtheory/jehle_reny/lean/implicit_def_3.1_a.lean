import Mathlib

/-- A firm acquires inputs (costs) and produces output (revenue).
    Profit is the difference between revenue and cost. -/
structure Firm where
  /-- Revenue earned from selling output on product markets -/
  revenue : ℝ
  /-- Expenditure (cost) from purchasing inputs on input markets -/
  cost : ℝ

/-- Profit of a firm: revenue minus cost -/
noncomputable def M.Profit (f : Firm) : ℝ := f.revenue - f.cost