<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span>
						<span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">Editar Producto</h4>
				</div>
				<div class="modal-body">
					<form action="insert" style="background: none" method="post"  id="form_edit-productos" name="form_productos">
						<input type="text" name="codigo" placeholder="Código de barras" class="form-control">
						<input type="text" name="descripcion" placeholder="Nombre del producto" class="form-control">
						<select name="categoria" class="form-control" id="categoria">
						 </select>
						 <select name="talla" class="form-control" id="talla">
						 </select>
						<input type="text" name="minimo" placeholder="Cantidad mínima para alertar" class="form-control">
					</form>
				</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
						<button type="button" class="btn btn-primary" id="btn_aceptar">Aceptar</button>
					</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
	$('#myModal').modal();	

		$("#form_edit-productos").validate({
				errorClass:"invalid",
				rules:{
					codigo:{required:true},
					descripcion:{required:true},
					categoria:{required:true},
					talla:{required:true},
					minimo:{required:true},
				},
				messages:{
					codigo:{required:"El producto debe tener un código de barras"},
					descripcion:{required:"El producto debe tener un nombre"},
					categoria:{required:"Se debe asignar una categoria al producto"},
					talla:{required:"Asigne una talla al producto"},
					minimo:{required:"Asigne el valor minimo que debe haber en stock"},
				},
				submitHandler: function(form){
					$.post("core/productos/controller_productos.php", {action:"update"}, function(){
						get_all();
						$('#myModal').modal("hide");
					});
			}
		});

	</script>

