<?php
var_dump($_POST);

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['userid'];
$item_name = $_POST['itemName'];
$item_desc = $_POST['itemDesc'];
$item_value = $_POST['itemValue'];
$item_state = $_POST['state'];
$item_local = $_POST['locality'];
$item_lat = $_POST['latitude'];
$item_long = $_POST['longitude'];
$image = $_POST['image'];

$sqlinsert = "INSERT INTO `tbl_items`(`item_owner`,`item_name`, `item_desc`, `item_value`, `item_state`,`item_local`,`item_lat`, `item_long`) VALUES ('$user_id','$item_name','$item_desc','$item_value','$item_state','$item_local','$item_lat','$item_long')";

if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);
	$decoded_string = base64_decode($image);
	$path = '../images/items/'.$filename.'.png';
	file_put_contents($path, $decoded_string);

    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>