<?php
$recepient = "verkunder614@gmail.com";
$siteName = "HTML-шаблон";
$name = trim($_POST["name"]);
$mail = trim($_POST["mail"]);
$message = "Имя: $name \nТелефон: $mail";
$pagetitle = "Заявка с сайта \"$siteName\"";
mail($recepient, $pagetitle, $message, "Content-type: text/plain; charset=\"utf-8\"\n From: $recepient");
?>
