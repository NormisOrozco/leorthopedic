<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="css/style.css">
	<link rel="stylesheet" href="css/fonts.css">
	<script type="text/javascript" src="js/script.js"></script>
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
		<label for="">Cliente</label><br>
		<input type="text" placeholder="Nombre del Cliente" id="campo_nombre" name="campo_nombre"/><br>
		<div class="boton" onclick="empieza()"><span class="icon-empezar"></span>Empezar
		</div>
	</form>
	<div id="diventas" class="invisible">
		<div id="venta_de">
		
		</div>
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
					<input class="campo_in" type="text" name="campo_codigo"/>
				</td>
				<td>
					<input class="campo_in" type="text" name="campo_cantidad"/>
				</td>
				<td>
					<div  class="boton"><span class="icon-agregar"></span>Agregar</div>
				</td>
			</tr>
		
		</table>
		</form>
		<hr>
		<table id="tabla_vta">
			<tr>
				<td class="tit_col"><label for="">Código</label></td>
				<td class="tit_col"><label for="">Producto</label></td>
				<td class="tit_col"><label for="">Precio U.</label></td>
				<td class="tit_col"><label for="">Cantidad</label></td>
				<td class="tit_col"><label for="">Subtotal</label></td>
				<td class="tit_col" colspan="2"><label for="">Acciones</label></td>
			</tr>
			<tr>
				<td class="campo"><label></label></td>
				<td class="campo"><label></label></td>
				<td class="campo"><label></label></td>
				<td class="campo"><label></label></td>
				<td class="campo"><label></label></td>
				<td class="botones"><button id="btn_quitar"><span class="icon-quitar"></span>Quitar</button></td>
				<td class="botones"><button id="btn_modificar"><span class="icon-modificar"></span>Editar</button></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td><label for="">Total</label></td>
				<td><label for="" class="lbl_total"></label></td>
			</tr>
		</table>
		<button id="btn_canc"><span class="icon-quitar" ></span>Cancelar</button>
		<button id="btn_term"><span class="icon-agregar" ></span>Terminar</button>
	</div> 
</body>
<script type="text/javascript">
	$("#form_uno").validate({
			errorClass:"invalid",
			rules:{
				campo_nombre:{required:true},
			},
			messages:{
				nombre:{required:"Introduzca un nombre para el cliente."},
			},
			submitHandler: empieza();
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
			submitHandler: nva_venta();
		});
</script>
</html>