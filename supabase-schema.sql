-- =============================================
-- SEO Project Manager — Supabase Schema
-- Paste this in Supabase > SQL Editor > Run
-- =============================================

-- PROJECTS
create table if not exists projects (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  type text not null check (type in ('seo','own','startup')),
  category text,
  location text,
  lang text,
  client_name text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- WEBSITES
create table if not exists websites (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade,
  url text not null,
  label text,
  is_main boolean default false,
  created_at timestamptz default now()
);

-- KEYWORDS
create table if not exists keywords (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade,
  keyword text not null,
  lang text default 'FR',
  created_at timestamptz default now()
);

-- GSC DATA (Google Search Console)
create table if not exists gsc_data (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade,
  website_url text not null,
  keyword text not null,
  clicks integer default 0,
  impressions integer default 0,
  ctr numeric(5,2) default 0,
  position numeric(5,1) default 0,
  date date not null,
  created_at timestamptz default now()
);

-- UPTIME LOGS
create table if not exists uptime_logs (
  id uuid primary key default gen_random_uuid(),
  website_id uuid references websites(id) on delete cascade,
  status text check (status in ('up','down','unknown')) default 'unknown',
  response_time_ms integer,
  checked_at timestamptz default now()
);

-- PAGESPEED DATA
create table if not exists pagespeed_data (
  id uuid primary key default gen_random_uuid(),
  website_id uuid references websites(id) on delete cascade,
  performance_score integer,
  lcp numeric(5,2),
  fid numeric(5,2),
  cls numeric(5,3),
  ttfb numeric(5,2),
  device text check (device in ('mobile','desktop')) default 'mobile',
  checked_at timestamptz default now()
);

-- Enable Row Level Security
alter table projects enable row level security;
alter table websites enable row level security;
alter table keywords enable row level security;
alter table gsc_data enable row level security;
alter table uptime_logs enable row level security;
alter table pagespeed_data enable row level security;

-- Allow all access (single-user app with login)
create policy "Allow all" on projects for all using (true);
create policy "Allow all" on websites for all using (true);
create policy "Allow all" on keywords for all using (true);
create policy "Allow all" on gsc_data for all using (true);
create policy "Allow all" on uptime_logs for all using (true);
create policy "Allow all" on pagespeed_data for all using (true);

-- Seed initial projects
insert into projects (id, name, type, category, location, lang, client_name) values
  ('11111111-1111-1111-1111-111111111111', 'LIMOSTAR', 'seo', 'Transport privé / location autocar Bruxelles', 'Brussels, Belgium', 'FR', 'Limostar SCS'),
  ('22222222-2222-2222-2222-222222222222', 'CAPTIVE', 'seo', 'Paintball Bruxelles (+ other categories)', 'Brussels, Belgium', 'FR', 'Captive Agency'),
  ('33333333-3333-3333-3333-333333333333', 'ASTRID GOLD', 'seo', 'Jewellery — diamonds, moissanite, gold, silver', 'Antwerp, Belgium', 'FR/NL/EN', 'Michael'),
  ('44444444-4444-4444-4444-444444444444', 'iSearchTrends', 'own', 'E-commerce trending products data platform', 'Online', 'EN', null),
  ('55555555-5555-5555-5555-555555555555', 'STARTUP IDEAS', 'startup', 'New startup concepts — in development', 'Remote', 'EN/FR/AR', null);

-- Seed websites for LIMOSTAR
insert into websites (project_id, url, is_main) values
  ('11111111-1111-1111-1111-111111111111', 'https://limostar.be', true),
  ('11111111-1111-1111-1111-111111111111', 'https://location-bus.be', false),
  ('11111111-1111-1111-1111-111111111111', 'https://locationautocar.be', false),
  ('11111111-1111-1111-1111-111111111111', 'https://lvc.brussels', false),
  ('11111111-1111-1111-1111-111111111111', 'https://transportbelgique.com', false),
  ('11111111-1111-1111-1111-111111111111', 'https://rentabus.be', false),
  ('11111111-1111-1111-1111-111111111111', 'https://busminibus.com', false),
  ('11111111-1111-1111-1111-111111111111', 'https://autocar-bruxelles.be', false),
  ('11111111-1111-1111-1111-111111111111', 'https://busrental.brussels', false),
  ('11111111-1111-1111-1111-111111111111', 'https://shuttle-service.be', false),
  ('11111111-1111-1111-1111-111111111111', 'https://rentbus.brussels', false),
  ('11111111-1111-1111-1111-111111111111', 'https://vtc.brussels', false),
  ('11111111-1111-1111-1111-111111111111', 'https://bus4rent.be', false),
  ('11111111-1111-1111-1111-111111111111', 'https://chauffeur.brussels', false),
  ('11111111-1111-1111-1111-111111111111', 'https://autocar-service.com', false),
  ('11111111-1111-1111-1111-111111111111', 'https://autocar.brussels', false),
  ('11111111-1111-1111-1111-111111111111', 'https://locationbus.be', false);

-- Seed websites for CAPTIVE
insert into websites (project_id, url, is_main) values
  ('22222222-2222-2222-2222-222222222222', 'https://paintballbruxelles.brussels', true);

-- Seed websites for ASTRID GOLD
insert into websites (project_id, url, is_main) values
  ('33333333-3333-3333-3333-333333333333', 'https://www.astridgold.be', true);

-- Seed websites for iSearchTrends
insert into websites (project_id, url, is_main) values
  ('44444444-4444-4444-4444-444444444444', 'https://isearchtrends.com', true);

-- Seed keywords for LIMOSTAR
insert into keywords (project_id, keyword, lang) values
  ('11111111-1111-1111-1111-111111111111', 'location autocar avec chauffeur Bruxelles', 'FR'),
  ('11111111-1111-1111-1111-111111111111', 'autocar privé Bruxelles', 'FR'),
  ('11111111-1111-1111-1111-111111111111', 'location minibus avec chauffeur Bruxelles', 'FR'),
  ('11111111-1111-1111-1111-111111111111', 'bus privé avec chauffeur Bruxelles', 'FR'),
  ('11111111-1111-1111-1111-111111111111', 'transfert aéroport autocar Bruxelles', 'FR'),
  ('11111111-1111-1111-1111-111111111111', 'location bus mariage Bruxelles', 'FR'),
  ('11111111-1111-1111-1111-111111111111', 'autocar pour événement Bruxelles', 'FR'),
  ('11111111-1111-1111-1111-111111111111', 'bus rental Brussels', 'EN'),
  ('11111111-1111-1111-1111-111111111111', 'charter bus Brussels', 'EN'),
  ('11111111-1111-1111-1111-111111111111', 'coach hire Brussels', 'EN'),
  ('11111111-1111-1111-1111-111111111111', 'airport transfer bus Brussels', 'EN'),
  ('11111111-1111-1111-1111-111111111111', 'corporate bus hire Brussels', 'EN'),
  ('11111111-1111-1111-1111-111111111111', 'shuttle service Brussels', 'EN'),
  ('11111111-1111-1111-1111-111111111111', 'wedding bus Brussels', 'EN');

-- Seed keywords for CAPTIVE
insert into keywords (project_id, keyword, lang) values
  ('22222222-2222-2222-2222-222222222222', 'paintball Bruxelles', 'FR'),
  ('22222222-2222-2222-2222-222222222222', 'paintball Brussels', 'EN');

-- Seed keywords for ASTRID GOLD
insert into keywords (project_id, keyword, lang) values
  ('33333333-3333-3333-3333-333333333333', 'diamonds Antwerp', 'EN'),
  ('33333333-3333-3333-3333-333333333333', 'loose diamonds Antwerp', 'EN'),
  ('33333333-3333-3333-3333-333333333333', 'moissanite jewellery', 'EN'),
  ('33333333-3333-3333-3333-333333333333', 'gold jewellery Antwerp', 'EN'),
  ('33333333-3333-3333-3333-333333333333', 'handcraft jewellery Antwerp', 'EN');
