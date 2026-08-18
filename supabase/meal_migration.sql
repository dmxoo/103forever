-- 급식표 기능용: Supabase SQL Editor에서 한 번 실행하세요.
create table if not exists public.meal_plans (id smallint primary key default 1 check (id = 1), image_path text not null, updated_at timestamptz not null default now());
alter table public.meal_plans enable row level security;
grant select on public.meal_plans to anon, authenticated;
grant insert, update, delete on public.meal_plans to authenticated;
drop policy if exists "Public reads meal plans" on public.meal_plans;
drop policy if exists "Admins manage meal plans" on public.meal_plans;
create policy "Public reads meal plans" on public.meal_plans for select using (true);
create policy "Admins manage meal plans" on public.meal_plans for all to authenticated using (public.is_admin()) with check (public.is_admin());
