-- Da a "Servicios" el mismo comportamiento histórico que "Informe": cada
-- servicio/mes guarda su propia foto de qué alumnos aplican, en vez de
-- recalcularse siempre contra el listado completo y actual de alumnos.

create table servicio_alumnos (
  id bigint generated always as identity primary key,
  servicio_id bigint not null references servicios(id) on delete cascade,
  alumno_id bigint not null references alumnos(identificacion) on delete cascade,
  created_at timestamptz not null default now(),
  user_id uuid not null default auth.uid(),
  owner_id uuid not null default auth.uid()
);

alter table servicio_alumnos enable row level security;

create policy "own rows" on servicio_alumnos for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());

grant select, insert, update, delete on servicio_alumnos to authenticated;
grant usage, select on servicio_alumnos_id_seq to authenticated;
