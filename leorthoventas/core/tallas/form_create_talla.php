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
					<form action="insert" style="background: none" method="post"  id="form_tallas" name="form_tallas">
						<input type="text" name="nombre" placeholder="Nombre de la talla" class="form-control">
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
		$("#form_tallas").validate({
				errorClass:"invalid",
				rules:{
					nombre:{required:true},
				},
				messages:{
					nombre:{required:"Se necesita un nombre para la nueva talla."},
				},
				submitHandler: function(form){
					alert("hola");
			}
		});

	</script>

