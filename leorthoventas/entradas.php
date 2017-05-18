<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="css/style.css">
	<link rel="stylesheet" href="css/fonts.css">
	<script type="text/javascript" src="js/script.js"></script>
	<script type="text/javascript" src="js/jquery.js"></script>
	<script type="text/javascript" src="js/jquery.validate.js"></script>
	<title>VENTAS LEORTHOPEDIC</title>
	<script>
		$(document).ready(function(){
			get_all_entradas();
			$("#content_table").on("click", "a.btn_", function(){
				var id=$(this).data("id");
				$.post("core/alumnos/controller_alumnos.php", {action:"delete",id_alumno:id},function(){
					get_all();
					alert("Alumno eliminado");
				});
			});

			$("#content_table").on("click", "a.btn_deta", function(){
				alert("Detalles");
			});
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
	<form action="" id="form_ent">
	<table>
		<tr>
			<th>Código</th>
			<th>Cantidad</th>
			<th>Costo</th>
			<th>Observaciones</th>
		</tr>
		<tr>
			<td><input type="text" class="campo_in" name="codigo"></td>
			<td><input type="text" class="campo_in" name="cantidad"></td>
			<td><input type="text" class="campo_in" name="costo"></td>
			<td><input type="text" class="campo_in" name="observaciones"></td>
			<td><button class="boton" type="submit" id="btn_acept"><span class="icon-agregar"></span>Aceptar</button></td>
			
		</tr> 
	</table>
	</form>
	<hr>
	<div id="divent">
		<table>
		<tr>
			<th class="tit_col">Producto</th>
			<th class="tit_col">Cantidad</th>
			<th class="tit_col">Fecha</th>
			<th class="tit_col">Observaciones</th>
			<th class="tit_col" id="col_acc">Acciones</th>
		</tr>
		<tbody id="content_table"></tbody>
		</table>
	</div>
</body>
<script>

		function get_all_entradas(){
			$.post("core/entradas/controller_entradas.php", {action:"get_all"}, function(res){
				var datos=JSON.parse(res);
				var cod_html="<option disabled='true' selected>Selecciona un semestre</option>";
				for(var i=0;i<datos.length;i++)
				{
					var info=datos[i];
					cod_html+="<tr><td> <label>"+info["producto"]+" </label></td><td> <label>"+info["cantidad"]+" </label></td><td> <label>"+info["fecha"]+" </label></td><td> <label>"+info["observaciones"]+" </label></td><a href='!#'class='btn_deta' data-id='"+info["id_producto"]+"'><span class='botones icon-info'></span>Detalles</a></td></div></tr>";
					$("#content_table").html(cod_html);
				}
				$("#semestre").html(cod_html);
			});	
		}

	$('#btn_acept').click(function(){
			$('#form_ent').submit();
			
	});

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
	</script>
</html>