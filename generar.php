<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/fonts.css">
    <link rel="stylesheet" href="css/bootstrap.css">
    <script type="text/javascript" src="js/script.js"></script>
    <script type="text/javascript" src="js/jquery.js"></script>
    <script type="text/javascript" src="js/bootstrap.js"></script>
    <script type="text/javascript" src="js/jquery.validate.js"></script>
    <title>GENERAR REPORTES</title>
</head>
<body>
<nav>
    <?php
    require_once("menu.php");
    ?>
</nav>
    <div class="divtop">
        <label for="">GENERAR REPORTES</label>
    </div>
    <div id="divrep">
        <div class="boton" id="btn_corte"><span class="icon-empezar"></span><a href="#!">Corte de Caja </a></div>
        <div class="boton"><span class="icon-empezar"></span><a href="reporte.html" target="_blank">Reporte Semanal </a></div>
        <div class="boton"><span class="icon-empezar"></span><a href="reporte.html" target="_blank">Reporte Mensual </a></div>
        <div class="boton"><span class="icon-empezar"></span><a href="reporte.html" target="_blank">Reporte Anual </a></div>
    </div>
    <aside id="container_modal"></aside>
</body>
<script>
    $("#btn_corte").click(function(){
        $('#container_modal').load("core/cortes/form_create_corte.php");
    })
</script>
</html>