<div class="modal fade" id="myModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span>
						<span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">Agregar Categoría</h4>
				</div>
				<div class="modal-body">
					<form  style="background: none" method="post"  id="form_categos" name="form_categos">
						<input value="insert" name="action" id="action" type="hidden">
						<input type="text" name="descripcion_c" placeholder="Nombre de la categoria" class="form-control">
					</form>
				</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
						<button type="button" class="btn btn-primary" id="btn_aceptar_catego">Aceptar</button>
					</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
	$('#myModal2').modal();	

$("#btn_aceptar_catego").click(function(){
	$('#form_categos').submit();
});
		$('#form_categos').validate({
				errorClass:"invalid",
				rules:{
					descripcion_c:{required:true},
				},
				messages:{
					descripcion_c:{required:"Se necesita un nombre para la nueva categoría."},
				},
				submitHandler: function(form){
					$.post("core/categorias/controller_categos.php", $('#form_categos').serialize(), function(){
						get_all_categos();
					});
				$('#myModal2').modal('hide');
				}
		});

	</script>
<script type="text/javascript" src="js/jquery.validate.js"></script>
