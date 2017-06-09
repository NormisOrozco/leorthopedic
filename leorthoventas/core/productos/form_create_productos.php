<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span>
						<span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">Agregar Producto</h4>
				</div>
				<div class="modal-body">
					<form action="insert" style="background: none" method="post"  id="form_productos" name="form_productos">
						<input value="insert" name="action" id="action" type="hidden">
						<input type="text" name="codigo" placeholder="Código de barras" class="form-control">
						<input type="text" name="descripcion" placeholder="Nombre del producto" class="form-control">
						<a id="btn_addcatego" href='#' class="btn btn-success"><span class="glyphicon glyphicon-plus"></span></a>
						<select name="categoria" class="form-control" id="categoria">
						 </select>
						<select name="talla" id="talla" class="form-control">
						</select>
						 <input type="text" name="cantidad" placeholder="Cantidad de entrantes" class="form-control">
						<input type="text" name="costo" placeholder="Costo de la entrada" class="form-control">
						<input type="text" name="observaciones" placeholder="Observaciones" class="form-control">
						<input type="text" name="minimo" placeholder="Cantidad mínima para alertar" class="form-control">
					</form>
				</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
						<button type="button" class="btn btn-primary" id="btn_aceptar_prod">Aceptar</button>
					</div>
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
	$('#myModal').modal();	

		get_all_categos();
		function get_all_categos(){
			$.post("core/categorias/controller_categos.php", {action:'get_all'}, function(res){
				console.log(res);
				var datos=JSON.parse(res);
				var cod_html="<option disabled='true' selected='true'>Seleccione categoria</option>";
				for (var i=0;i<datos.length;i++) 
				{
					var info=datos[i];
					cod_html+="<option>"+info['descripcion_c']+"</option>";
					//se insertan los datos a la tabla
				}
				$("#categoria").html(cod_html);
			});
		}

		get_all_tallas();
		function get_all_tallas(){
			$.post("core/tallas/controller_tallas.php", {action:"get_all"}, function(res){
				console.log(res);
				var datos=JSON.parse(res);
				var cod_html="<option disabled='true'>Seleccione talla</option>";
				for(var i=0;i<datos.length;i++)
				{
					var info=datos[i];
					cod_html+="<option>"+info['desc_talla']+"</option>";
				}
				$('#talla').html(cod_html);
			});
		}
		
		$('#btn_addcatego').click(function(){
			$("#container_modal_2").load("core/categorias/form_create_catego.php");
		});

		$('#btn_aceptar_prod').click(function(){
			$('#form_productos').submit();
		});

		$("#form_productos").validate({
				errorClass:"invalid",
				rules:{
					codigo:{required:true},
					descripcion:{required:true},
					categoria:{required:true},
					cantidad:{required:true},
					costo:{required:true},
					minimo:{required:true},
				},
				messages:{
					codigo:{required:"El producto debe tener un código de barras"},
					descripcion:{required:"El producto debe tener un nombre"},
					categoria:{required:"Se debe asignar una categoria al producto"},
					cantidad:{required:"Debe ingresar una cantidad para generar una nueva entrada"},
					costo:{required:"Introduzca el costo del paquete que ha llegado"},
					minimo:{required:"Asigne el valor minimo que debe haber en stock"},
				},
				submitHandler: function(form){
					$.post("core/productos/controller_productos.php", $('#form_productos').serialize(), function(){
						$('#myModal').modal("hide");
					});
			}
		});
	</script>
<script type="text/javascript" src="js/jquery.validate.js"></script>
