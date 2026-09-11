-- Corrige la política de las 3 tablas nuevas: de "cualquier autenticado ve todo"
-- a "cada quien ve solo lo suyo" (owner_id = auth.uid()), igual que alumnos/servicios/pagos.

drop policy "auth all" on informe_ingresos;
drop policy "auth all" on informe_ingreso_detalle;
drop policy "auth all" on informe_egresos;

create policy "own rows" on informe_ingresos for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
create policy "own rows" on informe_ingreso_detalle for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
create policy "own rows" on informe_egresos for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
