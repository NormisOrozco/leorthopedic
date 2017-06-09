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
	<script type="text/javascript" src="js/additional-methods.js"></script>
	<title>VENTAS LEORTHOPEDIC</title>
	<script>
		$(document).ready(function(){
			$("#content_table").on("click", "button.btn_quitar", function(){
				var id_venta=$(this).data("id");
				console.log("id de venta: "+id_venta);
				$('#modal_confirm_quitar').modal();
				$('#btn_confirm_quit').click(function(event){
				console.log("entro a la funcion del boton");
				$.post("core/ventas/controller_ventas.php", {action:"delete", id_venta:id_venta}, function(){
					get_all_ventas();
					get_total();
				});
				$('#modal_confirm_quitar').modal("hide");
				});
			});

			$("#content_table").on("click", "button.btn_editar", function(){
				var id_venta=$(this).data("id");
				console.log("id de venta: "+id_venta);
				$('#modal_editar').modal();
				$.post("core/ventas/controller_ventas.php", {action:"get_cantidad", id_venta:id_venta},function(res){
						var info;
						var datos=JSON.parse(res);
						info=datos[0][0];
						cantidad=info;
						console.log(info);
						$('#txt_editcant').val(cantidad);
						get_all_ventas();
					});
				$('#txt_id_venta').val(id_venta);
				$('#btn_confirm_edit').click(function(){
					console.log("entro a la funcion del boton");
					$('#form_edit').submit();
				});
			});
		});
	</script>
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
		<button class="boton" id="btn_emp"><span class="icon-empezar"></span>Empezar</Button>
	</form>
	<div id="diventas" class="invisible">
		<div id="venta_de">
		
		</div>
		<hr>
		<form action="insert" id="form_dos">
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
					<input value="insert_vta" name="action" id="action" type="hidden">
					<input class="campo_in" type="text" name="campo_codigo" id="campo_codigo"/>
				</td>
				<td>
					<input class="campo_in" type="text" name="campo_cantidad" id="campo_cantidad"/>
				</td>
				<td>
					<button id="btn_agregar" class="boton" type="submit"><span class="icon-agregar"></span>Agregar</button>
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
				<td><label>Total</label></td>
				<td><label id="lbl_total"></label></td>
			</tr>
		</table>
		<button id="btn_canc" class="btn btn-danger"><span class="icon-quitar"></span>Cancelar</button>
		<button id="btn_term" class="btn btn-success"><span class="icon-agregar"></span>Terminar</button>
	</div> 
	<aside id="container_modal"></aside>
</body>
<script type="text/javascript">
	function get_total(){
		$.post("core/ventas/controller_ventas.php", {action:"get_total"}, function(res){
			var  datos=JSON.parse(res);
			var info=datos[0];
			$('#lbl_total').html(info['total']);
		});
	}

	function get_all_ventas()
	{
		$.post("core/ventas/controller_ventas.php", {action:"get_all"}, function(res){
				var datos=JSON.parse(res);
				var cod_html;
				for(var i=0;i<datos.length;i++)
				{
					var info=datos[i];
					cod_html+="<tr><td class='campo'> <label>"+info['codigo']+" </label></td><td class='campo'> <label>"+info['producto']+" </label></td><td class='campo'> <label>"+info['precio']+" </label></td><td class='campo'> <label>"+info['cantidad']+"</label></td><td class='campo'> <label>"+info['subtotal']+"</label></td><td class='botones'><button class='btn_quitar btn btn-danger' data-id="+info['id_venta']+"><span class='icon-quitar'></span>Quitar</button></td><td class='botones'><button class='btn_editar btn btn-primary' data-id="+info['id_venta']+"><span class='icon-modificar'></span>Editar</button></td></tr>";
					$("#content_table").html(cod_html);
				}
			});	
	}
	$("#btn_newdev").click(function(){
		$("#container_modal").load("core/devoluciones/form_create_devolucion.php");
	});

	$('#btn_term').click(function(){
		$('#container_modal').load("core/ventas/form_finish_venta.php?total="+$('#lbl_total').text());
	});

	$("#form_uno").validate({
		errorClass: "invalid",
		rules:{
			campo_nombre:{required:true,
							lettersonly:true,
							maxlength:45},
		},
		messages:{
			campo_nombre:{required:"Introduzca el nombre del cliente."},
		},
		submitHandler: function(form)
		{

				var nombre=$('#campo_nombre').val();
			$.post("core/ventas/controller_ventas.php", {action:"insert_tkt", nombre:nombre}, function(){
				document.getElementById('form_uno').classList.add('invisible');
				document.getElementById('diventas').classList.remove("invisible");
				var cod_html='<label style="font-size: 1.5em;">Venta para '+nombre+'.</label>'; 
				document.getElementById('venta_de').innerHTML=cod_html;
				document.getElementById('diventas').classList.add("visible");
			});
		}
	});
	$("#form_dos").validate({
			errorClass:"invalid",
			rules:{
				campo_codigo:{required:true,
								alphanumeric:true,
								maxlength:45},
				campo_cantidad:{required:true,
								digits:true},
			},
			messages:{
				campo_codigo:{required:"Introduzca el código del producto.",
								alphanumeric:"Hay caracteres no válidos."},
				campo_cantidad:{required:"Especifique la cantidad de productos.",
								digits:"Sólo números."},
			},
			submitHandler: function(form){
				$.post("core/ventas/controller_ventas.php", $('#form_dos').serialize(), function(){
						get_all_ventas();
						get_total();
				});
			}

	});
</script>
</html>

<div class="modal fade" id="modal_editar" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span>
						<span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">Editar</h4>
				</div>
				<div class="modal-body">
				<form id="form_edit">
				<input type="hidden" id="txt_id_venta">
				<label>Cantidad de productos</label>
				<input type="text" placeholder="Cantidad" id="txt_editcant" name="txt_editcant" class="form-control">
				</form>
				</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
						<button type="button" class="btn btn-primary" id="btn_confirm_edit">Aceptar</button>
					</div>
			</div>
		</div>
	</div>



<div class="modal fade" id="modal_confirm_quitar" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span>
					<span class="sr-only">Close</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">Quitar producto</h4>
			</div>
			<div class="modal-body">
			¿De verdad desea quitar el producto de la lista?
			</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
					<button type="button" class="btn btn-primary" id="btn_confirm_quit">Aceptar</button>
				</div>
		</div>
	</div>
</div>
<script>
	$('#form_edit').validate({
		errorClass:"invalid",
			rules:{
				txt_editcant:{required:true,
								digits:true},
			},
			messages:{
				txt_editcant:{required:"Especifique la cantidad de productos.",
								digits:"Sólo números."},
			},
			submitHandler: function(form){
				var cantidad=$('#txt_editcant').val();
				var id_venta=$('#txt_id_venta').val();
			$.post("core/ventas/controller_ventas.php", {action:"update", id_venta:id_venta, cantidad:cantidad}, function(){
					$('#modal_editar').modal("hide");
					get_all_ventas();
					get_total();
				});
			}
	});

</script>
