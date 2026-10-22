-- Lamination Hub NFC Studio database schema
-- Run this in Supabase SQL Editor. Review your existing tables before applying.
create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.card_profiles (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  full_name text not null,
  business_name text,
  slug text not null unique,
  tagline text,
  phone text,
  whatsapp text,
  email text,
  address text,
  website text,
  instagram text,
  facebook text,
  maps_url text,
  logo_url text,
  services text[] not null default '{}',
  payment_url text,
  theme_color text not null default '#ff7a1a',
  is_active boolean not null default true
);

create or replace function public.set_card_profiles_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end;
$$;
drop trigger if exists card_profiles_updated_at on public.card_profiles;
create trigger card_profiles_updated_at before update on public.card_profiles
for each row execute function public.set_card_profiles_updated_at();

alter table public.admin_users enable row level security;
alter table public.card_profiles enable row level security;

-- Admin status is managed by trusted project owners in SQL; users cannot self-promote.
drop policy if exists "Admins can read own admin record" on public.admin_users;
create policy "Admins can read own admin record" on public.admin_users
for select to authenticated using (user_id = (select auth.uid()));

drop policy if exists "Public can read active card profiles" on public.card_profiles;
create policy "Public can read active card profiles" on public.card_profiles
for select to anon, authenticated using (is_active = true);

drop policy if exists "Admins can read all card profiles" on public.card_profiles;
create policy "Admins can read all card profiles" on public.card_profiles
for select to authenticated using (
  exists (select 1 from public.admin_users a where a.user_id = (select auth.uid()))
);

drop policy if exists "Admins can insert card profiles" on public.card_profiles;
create policy "Admins can insert card profiles" on public.card_profiles
for insert to authenticated with check (
  exists (select 1 from public.admin_users a where a.user_id = (select auth.uid()))
);

drop policy if exists "Admins can update card profiles" on public.card_profiles;
create policy "Admins can update card profiles" on public.card_profiles
for update to authenticated using (
  exists (select 1 from public.admin_users a where a.user_id = (select auth.uid()))
) with check (
  exists (select 1 from public.admin_users a where a.user_id = (select auth.uid()))
);

drop policy if exists "Admins can delete card profiles" on public.card_profiles;
create policy "Admins can delete card profiles" on public.card_profiles
for delete to authenticated using (
  exists (select 1 from public.admin_users a where a.user_id = (select auth.uid()))
);

grant select on public.card_profiles to anon, authenticated;
grant insert, update, delete on public.card_profiles to authenticated;
grant select on public.admin_users to authenticated;

-- After creating your admin user under Supabase Authentication > Users,
-- replace ADMIN_USER_UUID below and run this statement separately:
-- insert into public.admin_users(user_id) values ('ADMIN_USER_UUID') on conflict do nothing;
