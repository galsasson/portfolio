<?php
	header("content-type: text/xml");

	require 'dbconfig.php';
	
	$con = mysql_connect(DB_HOST, DB_USER, DB_PASS);
	if (!$con) {
		echo "error: connection";
		return;
	}
	
	mysql_select_db(DB_NAME, $con);
	
	$userID = $_REQUEST['id'];
	$page = intval($_REQUEST['page']);
	$selection = intval($_REQUEST['selection']);
	
	$result = mysql_query("INSERT INTO ygwyg (id,page,selection) VALUES ('".mysql_real_escape_string($userID)."',".$page.",".$selection.");");
	if (!$result) {
		echo "error: insert";
		return;
	}
	
	echo "ok";

	mysql_close($con);
		
	return;
?>
