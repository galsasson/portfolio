<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Collective Childhood</title>
<link href="css/styles.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="//use.typekit.net/tky3whs.js"></script>
<script type="text/javascript">try{Typekit.load();}catch(e){}</script>
</head>

<?php

$SENTC = array();
$RESPS = array();

function error($str)
{
	echo "$str";
}

function fetchResults()
{
	global $SENTC, $RESPS;
	require 'dbconfig.php';
	
	$con = mysql_connect(DB_HOST, DB_USER, DB_PASS);
	if (!$con) {
		echo "error";
		return;
	}
	
	mysql_select_db(DB_NAME, $con);
	
	$result = mysql_query("SELECT * FROM sentences;");
	if (!$result) {
		error("SELECT * FROM sentences;");
		return;
	}
	
	$sentenceNum = 0;
	while($row = mysql_fetch_array($result))
	{
		// for each sentence, find a response (randomally)
//		echo "[".$row['id']."]:".$row['sentence'];
		$responsesRes = mysql_query("SELECT response FROM responses WHERE sid='".$row['id']."'");
		if (!$responsesRes) {
			error("SELECT response FROM responses WHERE sid='".$row['id']."'");
			return;
		}
		if (mysql_num_rows($responsesRes)==0) { $sentenceNum++; continue; }
		
		$fetchNum = rand(0, mysql_num_rows($responsesRes)-1);
		mysql_data_seek($responsesRes, $fetchNum);
		$response = mysql_fetch_assoc($responsesRes);
		if (!$response) { error("fetch_assoc"); return; }
		
		// put sentences and responses in two arrays;
		$SENTC[$row['position']] = $row['sentence'];  
		$RESPS[$row['position']] = $response['response'];
		
//		echo $response['response'];
		
		$sentenceNum++;
	}
}
?>

<body>
<div id="wrapper">
	<div id="content">
   
    <p>
      
      
      <?php
	
	global $SENTC, $RESPS;
	fetchResults();
	
	echo "I was born in " . $RESPS[0] . ". ";
	echo "my hometown is " . $RESPS[1] . ". ";
	echo "I used to love " . $RESPS[2] . ". ";
	echo "My fondest memory growing up was " . $RESPS[3] . ". ";
	echo $RESPS[4] . " reminds me of home. ";
	echo "I realy miss " . $RESPS[5] . ". ";
	echo "I was influenced by ". $RESPS[6] ." growing up. ";
	echo "The worst thing about my hometown was ". $RESPS[7] .". ";
	echo "I left my hometown when I was ".$RESPS[8].". ";
	echo "I left home because " .$RESPS[9] .". ";
	echo "The main thing I would change about my hometown is " .$RESPS[10]. ". ";
	echo "I would move back to my hometown if " .$RESPS[11]. ". ";
	echo "If I could live anywhere in the world, it would be ".$RESPS[12]. ". ";
    ?>
      
      
    </p>
      <br>
       <img src="img/refresh.png" width="30" height="30" alt="refresh" onClick="window.location.reload()">
	</div>
</div>
</body>
</html>