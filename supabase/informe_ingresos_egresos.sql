-- Informe de Ingresos y Egresos — nuevo módulo independiente de "servicios"
-- Ejecutar en Supabase SQL Editor.

create table informe_ingresos (
  id bigint generated always as identity primary key,
  concepto text not null,
  monto_base numeric not null,
  mes text not null,
  created_at timestamptz not null default now(),
  user_id uuid not null default auth.uid(),
  owner_id uuid not null default auth.uid()
);

-- Un renglón por alumno incluido en un concepto de ingreso de un mes.
-- Su sola existencia = "se contabilizó ese aporte"; quitar el renglón = excluir al alumno ese mes/concepto.
create table informe_ingreso_detalle (
  id bigint generated always as identity primary key,
  ingreso_id bigint not null references informe_ingresos(id) on delete cascade,
  alumno_id bigint not null references alumnos(identificacion) on delete cascade,
  monto numeric not null,
  created_at timestamptz not null default now(),
  user_id uuid not null default auth.uid(),
  owner_id uuid not null default auth.uid()
);

create table informe_egresos (
  id bigint generated always as identity primary key,
  concepto text not null,
  monto numeric not null,
  fecha date not null,
  mes text not null,
  created_at timestamptz not null default now(),
  user_id uuid not null default auth.uid(),
  owner_id uuid not null default auth.uid()
);

alter table informe_ingresos enable row level security;
alter table informe_ingreso_detalle enable row level security;
alter table informe_egresos enable row level security;

-- Aislado por dueño (owner_id = auth.uid()): este proyecto tiene más de una
-- profesora/usuaria compartiendo el mismo proyecto Supabase (igual que
-- alumnos/servicios/pagos), NO es "using (true)".
create policy "own rows" on informe_ingresos for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
create policy "own rows" on informe_ingreso_detalle for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
create policy "own rows" on informe_egresos for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());

grant select, insert, update, delete on informe_ingresos, informe_ingreso_detalle, informe_egresos to authenticated;
grant usage, select on informe_ingresos_id_seq, informe_ingreso_detalle_id_seq, informe_egresos_id_seq to authenticated;
