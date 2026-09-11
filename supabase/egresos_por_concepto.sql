-- Permite que un egreso quede ligado a un concepto de ingreso específico
-- (además de al mes), para que cada concepto tenga su propio reporte con
-- sus ingresos Y sus egresos. ingreso_id queda opcional: un egreso general
-- del mes (no ligado a ningún concepto) sigue siendo válido.

alter table informe_egresos add column ingreso_id bigint references informe_ingresos(id) on delete cascade;
