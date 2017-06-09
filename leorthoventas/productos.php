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
	<title>PRODUCTOS EN STOCK</title>
	<script>
		$(document).ready(function(){
			get_all_pagot();
			$("#tbody_prods").on("click", "a.btn_editprod", function(){
				var codigo=$(this).data("id");
				console.log("en el boton "+codigo);
				$('#container_modal').load("core/productos/form_edit_productos.php?codigo="+codigo);
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
		<label for="" >PRODUCTOS EN STOCK</label>
	</div>
	<div  id="divprods">
		<div id="apuno">
			<div>
				<label for="" id="lbl_titulo">Detalles de productos en la tienda</label>
				<a id="btn_catalogo" class="btn btn-primary"><span class="glyphicon glyphicon-list-alt"></span>Catálogo</a>
				<div style="width: 180px; display: inline-block; margin-top: ;">
				<div class="input-group">
			        <input type="text" class="form-control" placeholder="Buscar producto...">
			        <span class="input-group-btn">
			          <button class="btn btn-default" type="button">
			            <span class="glyphicon glyphicon-search"></span>
			          </button>
			        </span>
			     </div>
			     </div>
			</div>
			<hr>
			<label for="">Todos los productos</label>
			<table id="tabla_productos">
				<tr>
					<th class="tit_col">Código</th>
					<th class="tit_col">Producto</th>
					<th class="tit_col">Talla <a id="btn_addtalla" href='#' class="btn btn-success"><span class="glyphicon glyphicon-plus"></span></a></th>
					<th class="tit_col">Precio</th>
					<th class="tit_col">Disponibles</th>
					<th class="tit_col" style="width: 4em;" colspan="2">Acciones</th>
				</tr>
				<tbody id="tbody_prods">
					
				</tbody>
				
			</table>
		</div>
		<div id="apdos">
			<div id="divprods2">
				<label for="">Productos por agotarse</label>
				<table id="tabla_productosw">
					<tr>
						<th class="tit_col">Descripción</th>
						<th class="tit_col">Disponibles</th>
						<th class="tit_col" style="width: 5em;">Detalles</th>
					</tr>
					<tbody id="tbody_pagot">
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<aside id="container_modal"></aside>
	<aside id="container_modal2"></aside>
</body>
<script>
	$('#btn_catalogo').click(function(){
		$('#container_modal').load("core/productos/catalogo.php");
	});
	$('a.btn_infoprod').click(function(){
		$('#container_modal').load("core/productos/info_productos.php");
	});
	$('#btn_addtalla').click(function(){
		$('#container_modal').load("core/tallas/form_create_talla.php");
	});
	get_all_productos();
	function get_all_productos(){
		$.post("core/productos/controller_productos.php", {action:"get_all"}, function(res){
			var datos=JSON.parse(res);
			var cod_html="";
			for (var i=0;i<datos.length;i++) 
			{
				var info=datos[i];
				cod_html+="<tr><td class='campo'>"+info['codigo']+"</td><td class='campo'>"+info['producto']+"</td><td class='campo'>"+info['talla']+"</td><td class='campo'>"+info['precio']+"</td><td class='campo'>"+info['disponibles']+"</td><td style='text-align: center; width: 50px;' class='campo'><a href='#' class='btn_editprod' data-id="+info['codigo']+"><span class='btn btn-primary glyphicon glyphicon-pencil'></span></a></td><td style='text-align: center; width: 50px;' class='campo'><a href='#' class='btn_infoprod' data-id="+info['codigo']+"><span class='btn btn-warning icon-info'></span></a></td></tr>";
				//se insertan los datos a la tabla
			}
			$("#tbody_prods").html(cod_html);
		});
	}
	function get_all_pagot(){
		$.post("core/productos/controller_productos.php", {action:"get_all_pagot"}, function(res){
			var datos=JSON.parse(res);
			var cod_html="";
			for (var i=0;i<datos.length;i++) 
			{
				var info=datos[i];
				cod_html+="<tr><td class='camposwar'>"+info['descripcion']+"</td><td class='camposwar'>"+info['disponibles']+"</td><td class='camposwar'><a href='!#' class='btn_deta'><span class='btn btn-warning icon-info'></span></a></td></tr>";
				//se insertan los datos a la tabla
			}
			$("#tbody_pagot").html(cod_html);
		});
	}

			
</script>
</html>