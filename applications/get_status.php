<?php
function error($str)
{
	echo $str;
}

	require 'dbconfig.php';
	
	$responseStr = "Sorry... something went wrong";
	
	$con = mysql_connect(DB_HOST, DB_USER, DB_PASS);
	if (!$con) {
		//sendMessage("error connecting to the database");
		return;
	}
	
	mysql_select_db(DB_NAME, $con);
	
	$result = mysql_query("SELECT * FROM sentences ORDER BY position ASC");
	if (!$result)
	{
		error("error select from sentences");
		return;
	}
	
	$responses = array();
	while ($row = mysql_fetch_array($result))
	{
		$resResult = mysql_query("SELECT * FROM responses WHERE sid='".$row['id']."'");
		if (!$resResult)
		{
			error("error selecting from responses");
			return;
		}
		
		echo mysql_num_rows($resResult).",";
	}
	
	mysql_close($con);

?>