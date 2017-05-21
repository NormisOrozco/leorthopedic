<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="css/style.css">
	<link rel="stylesheet" href="css/fonts.css">
	<link rel="stylesheet" href="css/bootstrap.css">
	<script type="text/javascript" src="js/script.js"></script>
	<script type="text/javascript" src="js/jquery.js"></script>
	<script type="text/javascript" src="js/bootstrap.js"></script>
	<script type="text/javascript" src="js/jquery.validate.js"></script>
	<title>VENTAS LEORTHOPEDIC</title>
</head>
<body>
<nav class="menu-bar">
	<?php 
	require_once("menu.php");
	?>
</nav>
	
	<div class="divtop">
		<label for="">VENTAS - LEORTHOPEDIC</label>
	</div>
	<form action="" id="form_uno">
			<a id="btn_newdev" href='#' class="btn btn-warning"><span class="glyphicon glyphicon-repeat"></span>Devolución</a>
		<label for="">Cliente</label><br>
		<input type="text" placeholder="Nombre del Cliente" id="campo_nombre" name="campo_nombre"/><br>
		<div class="boton" id="btn_emp" onclick="empieza()"><span class="icon-empezar"></span>Empezar
	</div>
	</form>
	<div id="diventas" class="invisible">
		<div id="venta_de">
		
		</div>
		<hr>
		<form action="" id="form_dos">
		<table id="tabla_nvo">
			<tr>
				<td>
					<label class="titcol" for="">Código</label>
				</td>
				<td>
				<label class="titcol" for="">Cantidad</label>
				</td>
			</tr>
			<tr>
				<td>
					<input class="campo_in" type="text" name="campo_codigo" id="campo_codigo"/>
				</td>
				<td>
					<input class="campo_in" type="text" name="campo_cantidad" id="campo_cantidad"/>
				</td>
				<td>
					<button id="btn_emp" class="boton" type="submit"><span class="icon-agregar"></span>Agregar</button>
				</td>
			</tr>
		
		</table>
		</form>
		<hr>
		<table id="tabla_vta">
			<tr>
				<th class="tit_col" style="text-align: center;"><label>Código</label></th>
				<th class="tit_col" style="text-align: center;"><label>Producto</label></th>
				<th class="tit_col" style="text-align: center;"><label>Precio U.</label></th>
				<th class="tit_col" style="text-align: center;"><label>Cantidad</label></th>
				<th class="tit_col" style="text-align: center;"><label>Subtotal</label></th>
				<th class="tit_col"  style="text-align: center;" colspan="2"><label for="">Acciones</label></td>
			</tr>
				<tbody id="content_table"></tbody>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td><label for="">Total</label></td>
				<td><label for="" class="lbl_total"></label></td>
			</tr>
		</table>
		<button id="btn_canc" class="btn btn-danger"><span class="icon-quitar"></span>Cancelar</button>
		<button id="btn_term" class="btn btn-success"><span class="icon-agregar"></span>Terminar</button>
	</div> 
	<aside id="container_modal"></aside>
</body>
<script type="text/javascript">
	get_all_ventas();
	function get_all_ventas()
	{
		$.post("core/ventas/controller_ventas.php", {action:"get_all"}, function(res){
				var datos=JSON.parse(res);
				var cod_html;
				for(var i=0;i<datos.length;i++)
				{
					var info=datos[i];
					cod_html+="<tr><td class='campo'> <label>"+info["codigo"]+" </label></td><td class='campo'> <label>"+info["producto"]+" </label></td><td class='campo'> <label>"+info["precio"]+" </label></td><td class='campo'> <label>"+info["cantidad"]+"</label></td><td class='campo'> <label>"+info["subtotal"]+"</label></td><td class='botones'><button id='btn_quitar'><span class='icon-quitar'></span>Quitar</button></td><td class='botones'><button id='btn_modificar'><span class='icon-modificar'></span>Editar</button></td></tr>";
					$("#content_table").html(cod_html);
				}
			});	
	}
	$("#btn_newdev").click(function(){
		$("#container_modal").load("core/devoluciones/form_create_devolucion.php");
	});

	$("#form_dos").validate({
			errorClass:"invalid",
			rules:{
				campo_codigo:{required:true},
				campo_cantidad:{required:true},
			},
			messages:{
				campo_codigo:{required:"Introduzca el código del producto."},
				campo_cantidad:{required:"Especifique la cantidad de productos."},
			},
			submitHandler: function(form){

				$.post("core/ventas/controller_ventas.php", $('#form_dos').serialize(), function(){
					get_all_ventas();
				});
			}

		});
</script>
</html>