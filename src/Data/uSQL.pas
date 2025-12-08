unit uSQL;

interface

const
conUpdate = 1;
conInsert = 0;

//Permisos -------------------------------------------------------------------------------------------------------
Permisos_Listado = 'Select * from Public."permisos" Where "activo" = :pactivo';
Permisos_Filtrado =  ' and UPPER("Nombre") like :pnombre ';
//FIN Permisos --------------------------------------------------------------------------------------------------



//Entidad --------------------------------------------------------------------------------------------------------
Entidad_login = 'Select * from Public."entidad" where "activo"=true and id_tipo_entidad=:ptipoentidad' ;
Entidad_select = 'Select * from Public."entidad" where "id_entidad"=:pid_entidad';
Entidad_listado = 'SELECT * FROM public.entidad Where "activo" = :pactivo and id_tipo_entidad=:ptipoentidad';

//filtros comunes
Entidad_Filtrado = ' and UPPER("detalle_documento") like :pdocumento or'+
                   ' UPPER("nombre") like :pnombre or'+
                   ' UPPER("apellidos") like :papellidos or'+
                   ' UPPER("empresa") like :pempresa or'+
                   '"telefono1" like :ptelefono1 or'+
                   '"telefono2" like :ptelefono2 or'+
                   ' UPPER("email") like :pemail';
//FIN Entidad ---------------------------------------------------------------------------------------------------

implementation

end.
