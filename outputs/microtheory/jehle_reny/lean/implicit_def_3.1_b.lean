import Mathlib

/-- Profit is defined as the difference between the revenue a firm earns
    from selling its output and the expenditure it makes buying its inputs. -/
def profit (revenue expenditure : ℝ) : ℝ := revenue - expenditure