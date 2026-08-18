-- 공휴일 관리 기능용: Supabase SQL Editor에서 한 번 실행하세요.
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
alter table public.holidays enable row level security;
grant select on public.holidays to anon, authenticated;
grant insert, update, delete on public.holidays to authenticated;
drop policy if exists "Public reads holidays" on public.holidays;
drop policy if exists "Admins manage holidays" on public.holidays;
create policy "Public reads holidays" on public.holidays for select using (true);
create policy "Admins manage holidays" on public.holidays for all to authenticated using (public.is_admin()) with check (public.is_admin());
