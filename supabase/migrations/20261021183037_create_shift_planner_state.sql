/*
# Create shift planner state storage

1. New Tables
- `shift_planner_state` stores the single shared workspace for this no-login prototype.
- `id` is the stable workspace key.
- `data` contains the app's structured tasks, targets, metric snapshots, logs, notes, victories, and completed shifts.
- `updated_at` records the most recent successful save.

2. Security
- Row level security is enabled.
- The app intentionally has no sign-in screen, so anon and authenticated roles can read and update the shared workspace.
- Separate policies cover SELECT, INSERT, UPDATE, and DELETE.

3. Notes
- The frontend keeps a local backup so the interface remains usable during a temporary network failure.
- The database row is updated as a whole, which preserves the relationship between current values and historical snapshots.
*/

CREATE TABLE IF NOT EXISTS shift_planner_state (
  id text PRIMARY KEY,
  data jsonb NOT NULL DEFAULT '{}'::jsonb,
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE shift_planner_state ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_read_shift_planner_state" ON shift_planner_state;
CREATE POLICY "anon_read_shift_planner_state" ON shift_planner_state
  FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_shift_planner_state" ON shift_planner_state;
CREATE POLICY "anon_insert_shift_planner_state" ON shift_planner_state
  FOR INSERT TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_shift_planner_state" ON shift_planner_state;
CREATE POLICY "anon_update_shift_planner_state" ON shift_planner_state
  FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_shift_planner_state" ON shift_planner_state;
CREATE POLICY "anon_delete_shift_planner_state" ON shift_planner_state
  FOR DELETE TO anon, authenticated USING (true);
