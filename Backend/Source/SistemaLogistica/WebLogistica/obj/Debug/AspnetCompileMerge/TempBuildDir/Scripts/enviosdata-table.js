
$(document).ready(function () {

    var oTable = $('#enviosDataTable').dataTable({
        "bServerSide": true,
        "sAjaxSource": "/Home/AjaxHandler",
        "bProcessing": true,
        "bAutoWidth": false,
        "oLanguage": {
            "sProcessing": "Procesando...",
            "sLengthMenu": "Mostrar _MENU_ registros",
            "sZeroRecords": "No se encontraron resultados",
            "sEmptyTable": "Ningún dato disponible en esta tabla",
            "sInfo": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
            "sInfoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
            "sInfoFiltered": "(filtrado de un total de _MAX_ registros)",
            "sInfoPostFix": "",
            "sSearch": "Buscar:",
            "sUrl": "",
            "sInfoThousands": ",",
            "sLoadingRecords": "Cargando...",
            "oPaginate": {
                "sFirst": "Primero",
                "sLast": "Último",
                "sNext": "Siguiente",
                "sPrevious": "Anterior"
            },
            "oAria": {
                "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
                "sSortDescending": ": Activar para ordenar la columna de manera descendente"
            }
        },
        "aoColumnDefs": [
            { "sWidth": "10%", "aTargets": 0 },
            { "sWidth": "5%", "aTargets": 1 },
            { "sWidth": "13%", "aTargets": 2 },
            { "sWidth": "12%", "aTargets": 3 },
            { "sWidth": "10%", "aTargets": 4 },
            { "sWidth": "10%", "aTargets": 5 },
            { "sWidth": "15%", "aTargets": 6 },
            { "sWidth": "15%", "aTargets": 7 }
        ],
        "aoColumns": [
            {
                "sName": "IdEnvio",
                "sTitle": "Acciones",
                "bSearchable": false,
                "bSortable": false,
                "fnRender": function (oObj) {
                    return '<a href=\"Envio/Details/' + oObj.aData[0] + '\"><img border="0" alt="W3Schools" src="/Content/images/edit_icon.png" width="25" height="25" style="margin: 0px 10px"></a><a href=\"Envio/Delete/' + oObj.aData[0] + '\"><img border="0" alt="W3Schools" src="/Content/images/delete_icon.png" width="25" height="25"></a>';
                }
            },
            {
                "sName": "DescEnvio",
                "sTitle": "Envio",
                "bSortable": true,
                "bSearchable": true,
            },
            {
                "sName": "DescCLiente",
                "sTitle": "Cliente",
                "bSortable": true,
                "bSearchable": true,
            },
            {
                "sName": "DescTransportista",
                "sTitle": "Transportista",
                "bSortable": true,
                "bSearchable": true,
            },
            {
                "sName": "DescEstado",
                "sTitle": "Estado",
                "bSortable": true,
                "bSearchable": true,
            },
            {
                "sName": "FechaCarga",
                "sTitle": "Carga",
                "bSortable": true,
                "bSearchable": false,
            },
            {
                "sName": "FechaEnvio",
                "sTitle": "Envio",
                "bSortable": true,
                "bSearchable": false,
            }
        ]
    });
});