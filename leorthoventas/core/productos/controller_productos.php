<?php 
	require("../conexion.php");
	switch ($_POST['action']){
		case 'insert':
			$codigo=$_POST['codigo'];
			$descripcion=$_POST['descripcion'];
			$categoria=$_POST['categoria'];
			$cantidad=$_POST['cantidad'];
			$costo=$_POST['costo'];
			$observaciones=$_POST['observaciones'];
			$minimo=$_POST['minimo'];
			$sql="call nvo_prod('".$codigo."','".$descripcion."','".$categoria."',".$cantidad.",".$costo.",'".$observaciones."',".$minimo.");";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			break;
		case 'get_all':
			//$sql="SELECT *from producto;";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			while($row=$result->fetch_array())
				$datos[]=$row;
			print_r(json_encode($datos));
			break;
		default:
			printf("entro al default");
			break;
	}
 ?>