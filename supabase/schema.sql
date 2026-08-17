-- Supabase SQL Editor에서 한 번에 실행하세요.
create extension if not exists "pgcrypto";

create table if not exists public.admin_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  is_admin boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 100),
  content text not null check (char_length(content) between 1 and 5000),
  is_important boolean not null default false,
  image_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table if not exists public.schedules (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 100),
  description text not null default '' check (char_length(description) <= 2000),
  event_date date not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists schedules_event_date_idx on public.schedules(event_date);
create index if not exists announcements_created_at_idx on public.announcements(created_at desc);

create or replace function public.set_updated_at() returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;
drop trigger if exists announcements_updated_at on public.announcements;
create trigger announcements_updated_at before update on public.announcements for each row execute function public.set_updated_at();
drop trigger if exists schedules_updated_at on public.schedules;
create trigger schedules_updated_at before update on public.schedules for each row execute function public.set_updated_at();

-- security definer를 사용하여 RLS 재귀 참조 없이 관리자 여부를 확인합니다.
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.admin_profiles where id = auth.uid() and is_admin = true);
$$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to anon, authenticated;

alter table public.admin_profiles enable row level security;
alter table public.announcements enable row level security;
alter table public.schedules enable row level security;
grant select on public.announcements, public.schedules to anon, authenticated;
grant select on public.admin_profiles to authenticated;
grant insert, update, delete on public.announcements, public.schedules to authenticated;

-- 기존 정책을 삭제해 이 파일을 다시 실행해도 안전합니다.
drop policy if exists "Public reads announcements" on public.announcements;
drop policy if exists "Admins manage announcements" on public.announcements;
drop policy if exists "Public reads schedules" on public.schedules;
drop policy if exists "Admins manage schedules" on public.schedules;
drop policy if exists "Users read own profile" on public.admin_profiles;
create policy "Public reads announcements" on public.announcements for select using (true);
create policy "Admins manage announcements" on public.announcements for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "Public reads schedules" on public.schedules for select using (true);
create policy "Admins manage schedules" on public.schedules for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "Users read own profile" on public.admin_profiles for select to authenticated using (id = auth.uid());

-- 가입한 관리자의 UUID를 확인한 뒤 아래 한 줄의 UUID만 바꿔 실행하세요.
-- insert into public.admin_profiles (id, is_admin) values ('관리자-사용자-UUID', true)
-- on conflict (id) do update set is_admin = true;
