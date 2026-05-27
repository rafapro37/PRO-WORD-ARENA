-- PRO WORLD ARENA — Schema completo
-- Execute este arquivo ANTES do supabase_rls.sql

-- ─── USUARIOS ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS usuarios (
  id TEXT PRIMARY KEY,
  name TEXT,
  username TEXT UNIQUE,
  email TEXT,
  password TEXT,
  role TEXT NOT NULL DEFAULT 'PLAYER',
  plan TEXT DEFAULT 'FREE',
  plan_status TEXT DEFAULT 'ACTIVE',
  status TEXT DEFAULT 'ACTIVE',
  organizador_id TEXT,
  liga_id TEXT,
  experience_preference TEXT,
  organization JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── FEDERACOES ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS federacoes (
  id TEXT PRIMARY KEY,
  organizador_id TEXT NOT NULL,
  name TEXT NOT NULL,
  slug TEXT UNIQUE,
  description TEXT,
  logo_url TEXT,
  banner_url TEXT,
  type TEXT DEFAULT 'STANDARD',
  experience_type TEXT,
  market_status TEXT DEFAULT 'CLOSED',
  social_links JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── CAMPEONATOS ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS campeonatos (
  id TEXT PRIMARY KEY,
  organizador_id TEXT NOT NULL,
  liga_id TEXT,
  name TEXT NOT NULL,
  sport TEXT NOT NULL,
  format TEXT NOT NULL,
  experience_type TEXT,
  tournament_type TEXT DEFAULT 'X11',
  status TEXT DEFAULT 'DRAFT',
  banner_url TEXT,
  primary_color TEXT,
  is_paid BOOLEAN DEFAULT FALSE,
  entry_fee TEXT,
  max_teams INTEGER,
  group_count INTEGER DEFAULT 1,
  swiss_rounds INTEGER DEFAULT 3,
  current_round INTEGER DEFAULT 0,
  phase TEXT,
  awards JSONB,
  social_links JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── TIMES ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS times (
  id TEXT PRIMARY KEY,
  organizador_id TEXT,
  tournament_id TEXT,
  liga_id TEXT,
  group_id TEXT,
  name TEXT NOT NULL,
  logo_url TEXT,
  owner_id TEXT,
  manager_id TEXT,
  roster JSONB DEFAULT '[]',
  played INTEGER DEFAULT 0,
  won INTEGER DEFAULT 0,
  drawn INTEGER DEFAULT 0,
  lost INTEGER DEFAULT 0,
  goals_for INTEGER DEFAULT 0,
  goals_against INTEGER DEFAULT 0,
  points INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── PARTIDAS ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS partidas (
  id TEXT PRIMARY KEY,
  organizador_id TEXT,
  tournament_id TEXT NOT NULL,
  team_a_id TEXT,
  team_b_id TEXT,
  team_a_name TEXT,
  team_b_name TEXT,
  score_a INTEGER,
  score_b INTEGER,
  home_score INTEGER,
  away_score INTEGER,
  is_finished BOOLEAN DEFAULT FALSE,
  round INTEGER DEFAULT 1,
  stage TEXT,
  group_id TEXT,
  date BIGINT,
  mvp_id TEXT,
  events JSONB DEFAULT '[]',
  player_stats JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── JOGADORES ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS jogadores (
  id TEXT PRIMARY KEY,
  organizador_id TEXT,
  tournament_id TEXT,
  team_id TEXT,
  user_id TEXT,
  name TEXT NOT NULL,
  position TEXT,
  goals INTEGER DEFAULT 0,
  assists INTEGER DEFAULT 0,
  rating NUMERIC(4,2) DEFAULT 0,
  matches_played INTEGER DEFAULT 0,
  yellow_cards INTEGER DEFAULT 0,
  red_cards INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── PERFIS ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS perfis (
  id TEXT PRIMARY KEY,
  user_id TEXT UNIQUE NOT NULL,
  liga_id TEXT,
  organizador_id TEXT,
  team_name TEXT,
  team_logo_url TEXT,
  photo_url TEXT,
  bio TEXT,
  positions JSONB DEFAULT '[]',
  mode TEXT DEFAULT 'VIRTUAL',
  club_data JSONB,
  market_status TEXT DEFAULT 'DISPONIVEL',
  transfer_value NUMERIC DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── PARTICIPANTES ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS participantes (
  id TEXT PRIMARY KEY,
  organizador_id TEXT,
  tournament_id TEXT NOT NULL,
  team_owner_id TEXT,
  usuario_id TEXT,
  team_name TEXT,
  team_logo_url TEXT,
  status TEXT DEFAULT 'PENDING',
  payment_id TEXT,
  payment_status TEXT,
  paid_at TIMESTAMPTZ,
  roster JSONB DEFAULT '[]',
  timestamp BIGINT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── NOTICIAS ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS noticias (
  id TEXT PRIMARY KEY,
  organizador_id TEXT,
  liga_id TEXT,
  title TEXT,
  content TEXT,
  image_url TEXT,
  is_pinned BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── ANUNCIOS ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS anuncios (
  id TEXT PRIMARY KEY,
  organizador_id TEXT,
  liga_id TEXT,
  title TEXT,
  description TEXT,
  image_url TEXT,
  link TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── MERCADO TRANSFERENCIAS ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS mercado_transferencias (
  id TEXT PRIMARY KEY,
  organizador_id TEXT,
  liga_id TEXT,
  player_id TEXT,
  player_name TEXT,
  from_team_id TEXT,
  to_team_id TEXT,
  value NUMERIC DEFAULT 0,
  status TEXT DEFAULT 'DISPONIVEL',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── MOVIMENTACOES ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS movimentacoes (
  id TEXT PRIMARY KEY,
  organizador_id TEXT,
  usuario_id TEXT,
  liga_id TEXT,
  type TEXT,
  description TEXT,
  value NUMERIC DEFAULT 0,
  timestamp BIGINT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── PROPOSTAS ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS propostas (
  id TEXT PRIMARY KEY,
  organizador_id TEXT,
  liga_id TEXT,
  jogador_id TEXT,
  from_team_id TEXT,
  to_team_id TEXT,
  value NUMERIC DEFAULT 0,
  status TEXT DEFAULT 'PENDENTE',
  timestamp BIGINT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── CONVITES LIGA ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS convites_liga (
  id TEXT PRIMARY KEY,
  organizador_id TEXT,
  liga_id TEXT,
  jogador_id TEXT,
  email TEXT,
  status TEXT DEFAULT 'pendente',
  timestamp BIGINT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── RANKING ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ranking (
  id TEXT PRIMARY KEY,
  organizador_id TEXT,
  liga_id TEXT,
  tournament_id TEXT,
  player_id TEXT,
  player_name TEXT,
  goals INTEGER DEFAULT 0,
  assists INTEGER DEFAULT 0,
  rating NUMERIC(4,2) DEFAULT 0,
  season TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── HALL DA FAMA ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS hall_fama (
  id TEXT PRIMARY KEY,
  organizador_id TEXT,
  liga_id TEXT,
  player_id TEXT,
  player_name TEXT,
  achievement TEXT,
  season TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─── ÍNDICES DE PERFORMANCE ───────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_campeonatos_organizador ON campeonatos(organizador_id);
CREATE INDEX IF NOT EXISTS idx_campeonatos_liga ON campeonatos(liga_id);
CREATE INDEX IF NOT EXISTS idx_times_organizador ON times(organizador_id);
CREATE INDEX IF NOT EXISTS idx_times_torneio ON times(tournament_id);
CREATE INDEX IF NOT EXISTS idx_partidas_organizador ON partidas(organizador_id);
CREATE INDEX IF NOT EXISTS idx_partidas_torneio ON partidas(tournament_id);
CREATE INDEX IF NOT EXISTS idx_jogadores_organizador ON jogadores(organizador_id);
CREATE INDEX IF NOT EXISTS idx_participantes_torneio ON participantes(tournament_id);
CREATE INDEX IF NOT EXISTS idx_federacoes_slug ON federacoes(slug);
CREATE INDEX IF NOT EXISTS idx_usuarios_organizador ON usuarios(organizador_id);
CREATE INDEX IF NOT EXISTS idx_perfis_usuario ON perfis(user_id);
-- ============================================================
-- PRO WORLD ARENA — Row Level Security (RLS)
-- Versão: Fase 4 — Multi-tenant isolado por organizador_id
-- Aplique este arquivo no SQL Editor do Supabase
-- ============================================================

-- ─── HELPERS ─────────────────────────────────────────────────────────────────
-- Função que verifica se o usuário autenticado é admin master
-- (o admin do sistema não usa Supabase Auth, então esta é uma segurança extra)
CREATE OR REPLACE FUNCTION is_authenticated()
RETURNS boolean AS $$
  SELECT auth.role() = 'authenticated';
$$ LANGUAGE sql SECURITY DEFINER;

-- ─── USUARIOS ─────────────────────────────────────────────────────────────────
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS usuarios_select ON usuarios;
DROP POLICY IF EXISTS usuarios_select_own ON usuarios;
DROP POLICY IF EXISTS usuarios_select_organizer ON usuarios;
DROP POLICY IF EXISTS usuarios_insert ON usuarios;
DROP POLICY IF EXISTS usuarios_update ON usuarios;
DROP POLICY IF EXISTS usuarios_delete ON usuarios;

-- Jogador lê seu próprio perfil
CREATE POLICY usuarios_select_own ON usuarios
  FOR SELECT USING (auth.uid()::text = id::text);

-- Organizador lê todos os usuários que pertencem à sua organização
CREATE POLICY usuarios_select_organizer ON usuarios
  FOR SELECT USING (
    auth.uid()::text = organizador_id::text
  );

CREATE POLICY usuarios_insert ON usuarios
  FOR INSERT WITH CHECK (auth.uid()::text = id::text);

CREATE POLICY usuarios_update ON usuarios
  FOR UPDATE USING (auth.uid()::text = id::text);

CREATE POLICY usuarios_delete ON usuarios
  FOR DELETE USING (auth.uid()::text = id::text);

-- ─── FEDERACOES ───────────────────────────────────────────────────────────────
ALTER TABLE federacoes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS federacoes_select ON federacoes;
DROP POLICY IF EXISTS federacoes_select_public ON federacoes;
DROP POLICY IF EXISTS federacoes_select_owner ON federacoes;
DROP POLICY IF EXISTS federacoes_insert ON federacoes;
DROP POLICY IF EXISTS federacoes_update ON federacoes;
DROP POLICY IF EXISTS federacoes_delete ON federacoes;

-- Federações públicas são visíveis por todos (página pública)
CREATE POLICY federacoes_select_public ON federacoes
  FOR SELECT USING (true);

CREATE POLICY federacoes_insert ON federacoes
  FOR INSERT WITH CHECK (auth.uid()::text = organizador_id::text);

-- Só o organizador dono pode editar/deletar
CREATE POLICY federacoes_update ON federacoes
  FOR UPDATE USING (auth.uid()::text = organizador_id::text);

CREATE POLICY federacoes_delete ON federacoes
  FOR DELETE USING (auth.uid()::text = organizador_id::text);

-- ─── CAMPEONATOS ──────────────────────────────────────────────────────────────
ALTER TABLE campeonatos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS campeonatos_select ON campeonatos;
DROP POLICY IF EXISTS campeonatos_select_public ON campeonatos;
DROP POLICY IF EXISTS campeonatos_insert ON campeonatos;
DROP POLICY IF EXISTS campeonatos_update ON campeonatos;
DROP POLICY IF EXISTS campeonatos_delete ON campeonatos;

-- Qualquer pessoa autenticada pode ver campeonatos (necessário para jogadores se inscreverem)
CREATE POLICY campeonatos_select_public ON campeonatos
  FOR SELECT USING (true);

CREATE POLICY campeonatos_insert ON campeonatos
  FOR INSERT WITH CHECK (auth.uid()::text = organizador_id::text);

-- Só o organizador dono edita
CREATE POLICY campeonatos_update ON campeonatos
  FOR UPDATE USING (auth.uid()::text = organizador_id::text);

CREATE POLICY campeonatos_delete ON campeonatos
  FOR DELETE USING (auth.uid()::text = organizador_id::text);

-- ─── PARTICIPANTES (inscrições) ───────────────────────────────────────────────
ALTER TABLE participantes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS participantes_select ON participantes;
DROP POLICY IF EXISTS participantes_insert ON participantes;
DROP POLICY IF EXISTS participantes_update ON participantes;
DROP POLICY IF EXISTS participantes_delete ON participantes;

-- Organizador vê todas inscrições dos seus torneios; jogador vê as suas
CREATE POLICY participantes_select ON participantes
  FOR SELECT USING (
    auth.uid()::text = usuario_id::text
    OR auth.uid()::text = team_owner_id::text
    OR auth.uid()::text = organizador_id::text
  );

CREATE POLICY participantes_insert ON participantes
  FOR INSERT WITH CHECK (is_authenticated());

-- Aprovação/rejeição: apenas organizador dono
CREATE POLICY participantes_update ON participantes
  FOR UPDATE USING (
    auth.uid()::text = organizador_id::text
    OR auth.uid()::text = team_owner_id::text
  );

CREATE POLICY participantes_delete ON participantes
  FOR DELETE USING (
    auth.uid()::text = organizador_id::text
    OR auth.uid()::text = team_owner_id::text
  );

-- ─── TIMES ────────────────────────────────────────────────────────────────────
ALTER TABLE times ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS times_select ON times;
DROP POLICY IF EXISTS times_select_public ON times;
DROP POLICY IF EXISTS times_insert ON times;
DROP POLICY IF EXISTS times_update ON times;
DROP POLICY IF EXISTS times_delete ON times;

-- Todos podem ver times (tabela de classificação pública)
CREATE POLICY times_select_public ON times
  FOR SELECT USING (true);

-- Organizer cria times; manager também pode criar o seu
CREATE POLICY times_insert ON times
  FOR INSERT WITH CHECK (
    auth.uid()::text = organizador_id::text
    OR auth.uid()::text = owner_id::text
    OR auth.uid()::text = manager_id::text
  );

-- Só dono/manager e organizador podem editar
CREATE POLICY times_update ON times
  FOR UPDATE USING (
    auth.uid()::text = organizador_id::text
    OR auth.uid()::text = owner_id::text
    OR auth.uid()::text = manager_id::text
  );

CREATE POLICY times_delete ON times
  FOR DELETE USING (
    auth.uid()::text = organizador_id::text
    OR auth.uid()::text = owner_id::text
  );

-- ─── PARTIDAS ─────────────────────────────────────────────────────────────────
ALTER TABLE partidas ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS partidas_select ON partidas;
DROP POLICY IF EXISTS partidas_insert ON partidas;
DROP POLICY IF EXISTS partidas_update ON partidas;
DROP POLICY IF EXISTS partidas_delete ON partidas;

-- Partidas são públicas (exibição de resultados)
CREATE POLICY partidas_select ON partidas
  FOR SELECT USING (true);

CREATE POLICY partidas_insert ON partidas
  FOR INSERT WITH CHECK (auth.uid()::text = organizador_id::text);

-- Só o organizador lança resultados
CREATE POLICY partidas_update ON partidas
  FOR UPDATE USING (auth.uid()::text = organizador_id::text);

CREATE POLICY partidas_delete ON partidas
  FOR DELETE USING (auth.uid()::text = organizador_id::text);

-- ─── JOGADORES ────────────────────────────────────────────────────────────────
ALTER TABLE jogadores ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS jogadores_select ON jogadores;
DROP POLICY IF EXISTS jogadores_insert ON jogadores;
DROP POLICY IF EXISTS jogadores_update ON jogadores;
DROP POLICY IF EXISTS jogadores_delete ON jogadores;

-- Jogadores são visíveis por todos (ranking/estatísticas)
CREATE POLICY jogadores_select ON jogadores
  FOR SELECT USING (true);

CREATE POLICY jogadores_insert ON jogadores
  FOR INSERT WITH CHECK (auth.uid()::text = organizador_id::text);

CREATE POLICY jogadores_update ON jogadores
  FOR UPDATE USING (auth.uid()::text = organizador_id::text);

CREATE POLICY jogadores_delete ON jogadores
  FOR DELETE USING (auth.uid()::text = organizador_id::text);

-- ─── PERFIS ───────────────────────────────────────────────────────────────────
ALTER TABLE perfis ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS perfis_select ON perfis;
DROP POLICY IF EXISTS perfis_insert ON perfis;
DROP POLICY IF EXISTS perfis_update ON perfis;
DROP POLICY IF EXISTS perfis_delete ON perfis;

-- Perfis são públicos
CREATE POLICY perfis_select ON perfis
  FOR SELECT USING (true);

CREATE POLICY perfis_insert ON perfis
  FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);

-- Só o próprio jogador edita o perfil
CREATE POLICY perfis_update ON perfis
  FOR UPDATE USING (auth.uid()::text = user_id::text);

CREATE POLICY perfis_delete ON perfis
  FOR DELETE USING (auth.uid()::text = user_id::text);

-- ─── MERCADO TRANSFERÊNCIAS ───────────────────────────────────────────────────
ALTER TABLE mercado_transferencias ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS mercado_transferencias_select ON mercado_transferencias;
DROP POLICY IF EXISTS mercado_transferencias_insert ON mercado_transferencias;
DROP POLICY IF EXISTS mercado_transferencias_update ON mercado_transferencias;
DROP POLICY IF EXISTS mercado_transferencias_delete ON mercado_transferencias;

CREATE POLICY mercado_transferencias_select ON mercado_transferencias
  FOR SELECT USING (true);

CREATE POLICY mercado_transferencias_insert ON mercado_transferencias
  FOR INSERT WITH CHECK (is_authenticated());

CREATE POLICY mercado_transferencias_update ON mercado_transferencias
  FOR UPDATE USING (is_authenticated());

CREATE POLICY mercado_transferencias_delete ON mercado_transferencias
  FOR DELETE USING (is_authenticated());

-- ─── RANKING / HALL DA FAMA ───────────────────────────────────────────────────
ALTER TABLE ranking ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS ranking_select ON ranking;
DROP POLICY IF EXISTS ranking_insert ON ranking;
DROP POLICY IF EXISTS ranking_update ON ranking;
DROP POLICY IF EXISTS ranking_delete ON ranking;

CREATE POLICY ranking_select ON ranking FOR SELECT USING (true);
CREATE POLICY ranking_insert ON ranking FOR INSERT WITH CHECK (is_authenticated());
CREATE POLICY ranking_update ON ranking FOR UPDATE USING (is_authenticated());
CREATE POLICY ranking_delete ON ranking FOR DELETE USING (is_authenticated());

ALTER TABLE hall_fama ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS hall_fama_select ON hall_fama;
DROP POLICY IF EXISTS hall_fama_insert ON hall_fama;
DROP POLICY IF EXISTS hall_fama_update ON hall_fama;
DROP POLICY IF EXISTS hall_fama_delete ON hall_fama;

CREATE POLICY hall_fama_select ON hall_fama FOR SELECT USING (true);
CREATE POLICY hall_fama_insert ON hall_fama FOR INSERT WITH CHECK (is_authenticated());
CREATE POLICY hall_fama_update ON hall_fama FOR UPDATE USING (is_authenticated());
CREATE POLICY hall_fama_delete ON hall_fama FOR DELETE USING (is_authenticated());

-- ─── NOTICIAS / ANUNCIOS ──────────────────────────────────────────────────────
ALTER TABLE noticias ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS noticias_select ON noticias;
DROP POLICY IF EXISTS noticias_insert ON noticias;
DROP POLICY IF EXISTS noticias_update ON noticias;
DROP POLICY IF EXISTS noticias_delete ON noticias;

CREATE POLICY noticias_select ON noticias FOR SELECT USING (true);

CREATE POLICY noticias_insert ON noticias
  FOR INSERT WITH CHECK (auth.uid()::text = organizador_id::text);

CREATE POLICY noticias_update ON noticias
  FOR UPDATE USING (auth.uid()::text = organizador_id::text);

CREATE POLICY noticias_delete ON noticias
  FOR DELETE USING (auth.uid()::text = organizador_id::text);

ALTER TABLE anuncios ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS anuncios_select ON anuncios;
DROP POLICY IF EXISTS anuncios_insert ON anuncios;
DROP POLICY IF EXISTS anuncios_update ON anuncios;
DROP POLICY IF EXISTS anuncios_delete ON anuncios;

CREATE POLICY anuncios_select ON anuncios FOR SELECT USING (true);

CREATE POLICY anuncios_insert ON anuncios
  FOR INSERT WITH CHECK (auth.uid()::text = organizador_id::text);

CREATE POLICY anuncios_update ON anuncios
  FOR UPDATE USING (auth.uid()::text = organizador_id::text);

CREATE POLICY anuncios_delete ON anuncios
  FOR DELETE USING (auth.uid()::text = organizador_id::text);

-- ─── MOVIMENTAÇÕES ────────────────────────────────────────────────────────────
ALTER TABLE movimentacoes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS movimentacoes_select ON movimentacoes;
DROP POLICY IF EXISTS movimentacoes_insert ON movimentacoes;
DROP POLICY IF EXISTS movimentacoes_update ON movimentacoes;
DROP POLICY IF EXISTS movimentacoes_delete ON movimentacoes;

CREATE POLICY movimentacoes_select ON movimentacoes
  FOR SELECT USING (auth.uid()::text = usuario_id::text);

CREATE POLICY movimentacoes_insert ON movimentacoes
  FOR INSERT WITH CHECK (auth.uid()::text = usuario_id::text);

CREATE POLICY movimentacoes_update ON movimentacoes
  FOR UPDATE USING (auth.uid()::text = usuario_id::text);

CREATE POLICY movimentacoes_delete ON movimentacoes
  FOR DELETE USING (auth.uid()::text = usuario_id::text);

-- ─── ÍNDICES DE PERFORMANCE (aplicar uma vez) ─────────────────────────────────
-- Descomente e execute separadamente se ainda não existirem

-- CREATE INDEX IF NOT EXISTS idx_campeonatos_organizador ON campeonatos(organizador_id);
-- CREATE INDEX IF NOT EXISTS idx_times_organizador ON times(organizador_id);
-- CREATE INDEX IF NOT EXISTS idx_times_torneio ON times(tournament_id);
-- CREATE INDEX IF NOT EXISTS idx_partidas_organizador ON partidas(organizador_id);
-- CREATE INDEX IF NOT EXISTS idx_partidas_torneio ON partidas(tournament_id);
-- CREATE INDEX IF NOT EXISTS idx_jogadores_organizador ON jogadores(organizador_id);
-- CREATE INDEX IF NOT EXISTS idx_participantes_organizador ON participantes(organizador_id);
-- CREATE INDEX IF NOT EXISTS idx_participantes_torneio ON participantes(tournament_id);
-- CREATE INDEX IF NOT EXISTS idx_federacoes_slug ON federacoes(slug);
-- CREATE INDEX IF NOT EXISTS idx_usuarios_organizador ON usuarios(organizador_id);
