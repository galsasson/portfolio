<?php
	header("content-type: text/html");
	
	echo "<html>\n";
	echo "<head>\n";
	echo "<title>You get what you give</title>\n";
	echo "</head>\n";
	echo "<body>\n";

	require 'dbconfig.php';
	
	$con = mysql_connect(DB_HOST, DB_USER, DB_PASS);
	if (!$con) {
		echo "error: connection";
		return;
	}
	
	mysql_select_db(DB_NAME, $con);
	
	$result = mysql_query("SELECT DISTINCT id FROM ygwyg;");
	if (!$result) {
		echo "error: insert";
		return;
	}
	
	$numPlayers = mysql_num_rows($result);
	echo "Number of players: ".$numPlayers."<br />\n";
	
	$numPlayersNoLies=0;
	$selections = array(0, 0, 0, 0);

	while ($row = mysql_fetch_array($result))
	{
		$resResult = mysql_query("SELECT * FROM ygwyg WHERE id='".$row['id']."'");
		if (!$resResult)
		{
			error("error selecting user \"".$row['id']."\"");
			return;
		}
		
		$playerPages=mysql_num_rows($resResult);
		if ($playerPages == 1) {
			$numPlayersNoLies++;
		}
		
		while ($pRow = mysql_fetch_array($resResult))
		{
			if ($pRow['page'] == 1) {
				$selections[$pRow['selection']]++;
			}
		}
	}
	
	echo "Number of players who didn't lie (chose not to play): ".$numPlayersNoLies."<br />\n";
	echo "<br />\n";
	echo "Common lies:<br />\n";
	echo "From a banner ad. : ".$selections[0]."<br />\n";
	echo "Google (or other search engine) : ".$selections[1]."<br />\n";
	echo "Newspaper ad. : ".$selections[2]."<br />\n";
	echo "TV or radio : ".$selections[3]."<br />\n";
		
	mysql_close($con);
		
	echo "</body>\n";
	echo "</html>\n";
	
	return;
?>
