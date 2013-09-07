<?php
	header("content-type: text/xml");
	echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
	
	require 'dbconfig.php';
	
	$responseStr = "Sorry... something went wrong";
	
	$con = mysql_connect(DB_HOST, DB_USER, DB_PASS);
	if (!$con) {
		//sendMessage("error connecting to the database");
		return;
	}
	
	mysql_select_db(DB_NAME, $con);
	
	$phoneNumber = $_REQUEST['From'];
	$message = $_POST['Body'];
	
	// check to see if it's the first time we get a message from this number
	$result = mysql_query('SELECT * FROM `requests` WHERE `phone` = \'' . $phoneNumber . '\'');
	if (!$result) {
		//sendMessage("error performing query");
		return;
	}
	
	$row = mysql_fetch_array($result);
	mysql_free_result($result);
	if (!$row) {
		// We didn't find a request to this phone number, so we should send this number a sentence to complete.
		mysql_query('LOCK TABLES sentences READ, sentences WRITE;');
		
		// select a sentence from the list
		$result = mysql_query('SELECT * FROM `sentences` ORDER BY sent_counter,position ASC');
		if (!$result) {
			//sendMessage("error selecting from sentences");
			mysql_query('UNLOCK TABLES;');
			return;
		}
		
		$row = mysql_fetch_array($result);
		mysql_free_result($result);
		// now we should have some sentences in 'row' if we dont have, that meens we already have 4 requests sent for each sentence
		if (!$row)
		{
			//sendMessage("Sorry, we cannot find a sentence to send you.");
			mysql_query('UNLOCK TABLES;');
			return;
		}
		
		// ok, so we have a sentence to send, increment sent_counter in sentences table add an entry to the requests table and send the sentence
		$newCounter = $row['sent_counter']+1;
		$result = mysql_query("UPDATE sentences SET sent_counter='".$newCounter."' WHERE id='".$row['id']."'");
		if (!$result) {
			//sendMessage("something went wrong when updating the sentences counter");
			mysql_query('UNLOCK TABLES;');
			return;
		}
		
		$result = mysql_query("INSERT INTO requests (phone,sid,received, story_number) VALUES ('".$phoneNumber."', '".$row['id']."', '0', '".$row['sent_counter']."');");
		if (!$result) {
			//sendMessage("error: cannot insert into requests table");
			mysql_query('UNLOCK TABLES;');
			return;
		}
		
		// everything went fine!!! send the sentence to the user
		mysql_query('UNLOCK TABLES;');
		sendMessage("Complete the phrase: ".$row['sentence']);
		return;
	}
	else {
		// if we are here, this is the second time we get an sms from this number.
		// This is probably a response with the complete message.
		
		// check if the user already responded to the sentence
		$result = mysql_query("SELECT * FROM requests WHERE phone='".$phoneNumber."'");
		if (!$result) {
			//sendMessage("error doing select from requests table");
			return;
		}
		
		$row = mysql_fetch_array($result);
		if (!$row) {
			//sendMessage("error fetching results after select from requests table");
			return;
		}
		
		$requestID = $row['id'];
		$responsePhone = $row['phone'];
		$responded = $row['received'];
		$storyNumber = $row['story_number'];
		$sentenceID = $row['sid'];
		
		// check if we already got a complete message from this phone number
		if ($responded == 1) {
			//sendMessage("We already got the message you sent. Thanks.");
			return;
		}
		
		// mark this request as responded in the requests table 
		$result = mysql_query("UPDATE requests SET received='1' WHERE id='".$requestID."'");
		if (!$result) {
			//sendMessage("cannot update requests table");
			return;
		}
		
		// find out the original sentence
		$result = mysql_query("SELECT sentence FROM sentences WHERE id='".$sentenceID."'"); 
		if (!$result) {
			//sendMessage("cannot find out original message");
			return;
		}
		
		$row = mysql_fetch_array($result);
		if (!$row)
		{
			//sendMessage("cannot get the original sentence results");
			return;
		}
		
		$origSentence = $row['sentence'];
		// TODO: do some message testing to see if the user repeated the beginning of the sentence
		
		// If the user repeater the sentence remove it. 
		$origSentence = str_replace("...","", $origSentence);
		$origSentence = trim($origSentence);
		$response = str_replace($origSentence, "", $message);
		$response = trim($response);
		
		// lowercase first letter
		$response[0] = strtolower($response[0]);
		
		// add this completed sentence to the responses table
		$result = mysql_query("INSERT INTO responses (phone,sid,response,story_number) VALUES ('".$responsePhone."','".$sentenceID."','".$response."','".$storyNumber."');");
		if (!$result) {
			//sendMessage("cannot insert into responses table");
			return;
		}
		
		sendMessage("Thank you!");
		return;
	}
?>

<?php
function sendMessage($str)
{
	echo "<Response><Sms>" . $str . "</Sms></Response>";
}
?>

<?php
	mysql_close($con);
?>
