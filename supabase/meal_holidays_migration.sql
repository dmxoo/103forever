-- 기존 Supabase 프로젝트의 SQL Editor에서 한 번 실행하세요.
create table if not exists public.meal_plans (
  id smallint primary key default 1 check (id = 1),
  image_path text not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.holidays (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 100),
  holiday_date date not null unique,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists holidays_holiday_date_idx on public.holidays(holiday_date);
drop trigger if exists holidays_updated_at on public.holidays;
create trigger holidays_updated_at before update on public.holidays for each row execute function public.set_updated_at();

alter table public.meal_plans enable row level security;
alter table public.holidays enable row level security;
grant select on public.meal_plans, public.holidays to anon, authenticated;
grant insert, update, delete on public.meal_plans, public.holidays to authenticated;
drop policy if exists "Public reads meal plans" on public.meal_plans;
drop policy if exists "Admins manage meal plans" on public.meal_plans;
drop policy if exists "Public reads holidays" on public.holidays;
drop policy if exists "Admins manage holidays" on public.holidays;
create policy "Public reads meal plans" on public.meal_plans for select using (true);
create policy "Admins manage meal plans" on public.meal_plans for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "Public reads holidays" on public.holidays for select using (true);
create policy "Admins manage holidays" on public.holidays for all to authenticated using (public.is_admin()) with check (public.is_admin());
