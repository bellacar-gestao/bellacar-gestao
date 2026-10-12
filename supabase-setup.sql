-- ===============================================================
-- BELLACAR VEÍCULOS - ESQUEMA DE BANCO DE DADOS SUPABASE
-- Execute este script no SQL Editor do seu projeto Supabase (supabase.com)
-- ===============================================================

-- 1. TABELA DE ESTOQUE DE VEÍCULOS (INVENTORY)
CREATE TABLE IF NOT EXISTS public.inventory (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  price NUMERIC DEFAULT 0,
  fipe NUMERIC DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'ready',
  actor TEXT DEFAULT 'Carlos Eduardo',
  category TEXT DEFAULT 'Hatch',
  image TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW())
);

-- 2. TABELA DE TAREFAS E ROTINA DIÁRIA (TASKS)
CREATE TABLE IF NOT EXISTS public.tasks (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  category TEXT DEFAULT 'Gravação',
  status TEXT NOT NULL DEFAULT 'todo',
  created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW())
);

-- 3. TABELA DE RESULTADOS E MÉTRICAS (RESULTS)
CREATE TABLE IF NOT EXISTS public.results (
  id TEXT PRIMARY KEY,
  type TEXT,
  title TEXT,
  date TEXT,
  views TEXT,
  leads TEXT,
  proposals TEXT,
  sales TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW())
);

-- 4. TABELA DE CONFIGURAÇÕES GERAIS E OFERTAS DO DIOGO (STORE_SETTINGS)
CREATE TABLE IF NOT EXISTS public.store_settings (
  key TEXT PRIMARY KEY,
  value TEXT,
  updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW())
);

-- 5. HABILITAR ROW LEVEL SECURITY (RLS) COM POLÍTICAS DE ACESSO LIVRE (ANON)
ALTER TABLE public.inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.store_settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public Full Access Inventory" ON public.inventory;
CREATE POLICY "Public Full Access Inventory" ON public.inventory FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public Full Access Tasks" ON public.tasks;
CREATE POLICY "Public Full Access Tasks" ON public.tasks FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public Full Access Results" ON public.results;
CREATE POLICY "Public Full Access Results" ON public.results FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public Full Access Settings" ON public.store_settings;
CREATE POLICY "Public Full Access Settings" ON public.store_settings FOR ALL USING (true) WITH CHECK (true);

-- 6. HABILITAR SINCRONIZAÇÃO EM TEMPO REAL (REALTIME)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND tablename = 'inventory'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.inventory;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND tablename = 'tasks'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.tasks;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND tablename = 'store_settings'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.store_settings;
  END IF;
END $$;
