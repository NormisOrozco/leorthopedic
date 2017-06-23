<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="css/style.css">
	<link rel="stylesheet" href="css/fonts.css">
	<link rel="stylesheet" href="css/bootstrap.css">
	<script type="text/javascript" src="js/jquery.js"></script>
	<script type="text/javascript" src="js/bootstrap.js"></script>
	<script type="text/javascript" src="js/jquery.validate.js"></script>
	<title>VENTAS LEORTHOPEDIC</title>
	<script>
		$(document).ready(function(){
			get_all_entradas();
			});

			$("#content_table").on("click", "a.btn_deta", function(){
				alert("Detalles");
			});
	</script>
</head>
<body>
<nav>
	<?php
	require_once("menu.php");
	?>
</nav>
	<div class="divtop">
		<label for="">ENTRADAS - LEORTHOPEDIC</label>
	</div>
	<form action="insert" id="form_ent">
	<table>
		<tr>
			<th  style="text-align: center;">Código</th>
			<th  style="text-align: center;">Cantidad</th>
			<th  style="text-align: center;">Costo</th>
			<th  style="text-align: center;">Clasificar</th>
			<th  style="text-align: center;">Observaciones</th>
		</tr>
		<tr>
			
			<td>
				<input value="insert" name="action" id="action" type="hidden">
				<input type="text" class="campo_in" name="codigo" id="codigo">
			</td>
			<td><input type="text" class="campo_in" name="cantidad"></td>
			<td><input type="text" class="campo_in" name="costo"></td>
			<td><a class="btn btn-default" id="btn_clasificar">Clasificar</a>
            </td>
			<td><input type="text" class="campo_in" name="observaciones"></td>
			<td><button class="boton" type="submit" id="btn_acept"><span class="icon-agregar"></span>Aceptar</button></td>
			
		</tr> 
	</table>
	</form>
	<hr>
	<div id="divent">
		<table id="tabla_entradas">
		<tr>
			<th class="tit_col">Producto</th>
			<th class="tit_col">Cantidad</th>
			<th class="tit_col">Fecha</th>
			<th class="tit_col">Observaciones</th>
			<th class="tit_col" style="width: 5em;">Detalles</th>
		</tr>
		<tbody id="content_table"></tbody>
		</table>
	</div>
</body>
<aside id="container_modal"></aside>
<aside id="container_modal_2"></aside>
<script>
get_all_entradas();
		function get_all_entradas(){
			$.post("core/entradas/controller_entradas.php", {action:"get_all"}, function(res){
				var datos=JSON.parse(res);
				var cod_html;
				for(var i=0;i<datos.length;i++)
				{
					var info=datos[i];
					cod_html+="<tr><td class='campo'> <label>"+info["producto"]+" </label></td><td class='campo'> <label>"+info["cantidad"]+" </label></td><td class='campo'> <label>"+info["fecha"]+" </label></td><td class='campo'><label>"+info["observaciones"]+"</label></td><td class='campo'><div class='btn_deta btn btn-warning'><span class='icon-info'></span></div></td></tr>";
					$("#content_table").html(cod_html);
				}
			});	
		}

	$("#form_ent").validate({
			errorClass:"invalid",
			rules:{
				codigo:{required:true},
				cantidad:{required:true},
				costo:{required:true},
			},
			messages:{
				codigo:{required:"Introduzca un código válido."},
				cantidad:{required:"Especifique una cantidad."},
				costo:{required:"Defina el costo."},
			},
			submitHandler: function(form){

			$.post("core/entradas/controller_entradas.php", $('#form_ent').serialize(), function(){
				get_all_entradas();
			});
		}
	});
    
    $('#btn_clasificar').click(function(){
       var codigo=$('#codigo').val(); 
        if(codigo==""){
            alert("Código no válido");
        }
        else{
           $('#container_modal').load("core/entradas/form_clasificar.php?codigo="+codigo); 
        }
    });
	</script>

</html>