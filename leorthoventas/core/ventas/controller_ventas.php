<?php 
	# $variable=0; SE CREAN VARIABLES CON $
	# echo $variable; SE IMPRIMEN DATOS CON ECHO Y SE REFERENCIA A LA VARIABLE CON $
	/*for ($i=0; $i<2000;$i++)
	{
		echo $i."<br>";
	}*/
	require_once("../conexion.php"); # NECESITA EN CONECTOR ANTES DE EMPEZAR
	switch ($_POST['action']) {
		case 'get_all':
			$sql="call ver_venta();"; #MANDA LLAMAR AL PROCEDIMIENTO DE VER VENTAS QUE SE ALMACENA EN LA BASE DE DATOS
			$result=$conexion->query($sql); #OBTIENE EL RESULTADO DEL QUERY EN LA VARIABLE RESULT
			$datos=array();#SE CREA UN ARRAY QUE SE LLAMA DATOS
			while($row=$result->fetch_array()) #MIENTRAS SE CREA UNA VARIABLE LLAMADA ROW PARA CADA FILA
				$datos[]=$row; #ESTA  SE GUARDA EN EL ARREGLO DE DATOS
			print_r(json_encode($datos)); #CONTROL,IMPRIME EL ARREGLO EN CONSOLA
			break;


		case 'delete':
			$sql='call nva_cancel('.$_POST["id_venta"].');'; #LLAMA A EJECUTAR EL PROCEDIMEINTO QUE CANCELA LA VENTA
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");

			break;
		/*
		case 'get_one':
			$sql='select *from alumnos where id_alumno="'.$_POST["id_alumno"].'";';
			break;*/
		case 'insert_tkt':
			$nombre=$_POST['nombre'];
			printf($nombre);
			$sql="call nvo_ticket('".$nombre."');";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			#inserta un nuevo ticket en la base de datos
			break;

		case 'insert_vta':
			$codigo=$_POST["campo_codigo"];
			$cantidad=$_POST["campo_cantidad"];
			$sql="call nva_venta(".$codigo.",".$cantidad.");";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			break;

		case 'update':
			$codigo=$_POST["campo_codigo"];
			$cantidad=$_POST["campo_cantidad"];
			$sql="call mod_cantventa(".$codigo.",".$cantidad.");";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			#actualiza la cantidad de productos en una venta
			break;
		case 'cancel':
			$pid_venta=$_POST["id_venta"];
			$sql="call nva_cancel(".$pid_venta.");";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			#cancela una venta y la bitacora
			break;

		case 'finish':
			$sql="call ter_venta();";
			$result=$conexion->query($sql)or trigger_error($conexion->error."[$sql]");
			#termina la venta y calcula el ticket
			break;

		default:
			# code...
			break;
	}
	$conexion->close();
 ?>