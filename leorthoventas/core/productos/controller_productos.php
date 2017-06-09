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
			$sql="SELECT *from vista_productos;";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			while($row=$result->fetch_array())
				$datos[]=$row;
			print_r(json_encode($datos));
			break;

		case 'get_all_pagot':
			$sql="SELECT *from vista_pagot;";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			while($row=$result->fetch_array())
				$datos[]=$row;
			print_r(json_encode($datos));
			break;

		case 'get_one':
			$p_codigo=$_POST['codigo'];
			$sql="SELECT *from vista_editproductos where codigo=".$p_codigo.";";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			while($row=$result->fetch_array())
				$datos[]=$row;
			print_r(json_encode($datos));
			break;

		case 'update':
			$p_codigo=$_POST['codigo'];
			$descripcion=$_POST['descripcion'];
			$categoria=$_POST['categoria'];
			$talla=$_POST['talla'];
			$minimo=$_POST['minimo'];
			$sql="CALL mod_prod('".$p_codigo."','".$descripcion."','".$categoria."','".$talla."',".$minimo.");";
			print_r($sql);
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			break; 

		case 'get_catalogo':
			$sql="Select productos.id_producto as id, descripcion_p as nombre, ruta from productos, rutas_catalogo where productos.id_producto=rutas_catalogo.id_producto;";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			while($row=$result->fetch_array())
				$datos[]=$row;
			print_r(json_encode($datos));
			break;

		case 'get_one_catalogo':
			$sql="Select productos.id_producto as id, descripcion_p as nombre, ruta from productos, rutas_catalogo where productos.id_producto=rutas_catalogo.id_producto and productos.id_producto=".$_POST['id'].";";
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