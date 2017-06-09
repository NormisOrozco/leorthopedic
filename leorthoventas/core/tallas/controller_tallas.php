<?php 
	require("../conexion.php");
	switch ($_POST['action']){
		case 'insert':
			$descripcion_c=$_POST['desc_talla'];
			$sql="call nva_talla('".$desc_talla."');";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			break;
		case 'get_all':
			$sql="SELECT *from tallas;";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			while($row=$result->fetch_array())
				$datos[]=$row;
			print_r(json_encode($datos));
			break;
		default:
			printf("entro al default");
			break;
	}
	$conexion->close();
 ?>