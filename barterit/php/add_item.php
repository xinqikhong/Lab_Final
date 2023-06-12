<?php
var_dump($_POST);

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

/*$sqlGetItemId = "SELECT item_id FROM tbl_items";
$result = $conn->query($sqlGetItemId);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $item_id = $row['item_id'];
} else {
    // If there are no rows, set item_id to 1
    $item_id = 1;
}*/

$user_id = $_POST['userid'];
$item_name = $_POST['itemName'];
$item_desc = $_POST['itemDesc'];
$item_value = $_POST['itemValue'];
$item_state = $_POST['state'];
$item_local = $_POST['locality'];
$item_lat = $_POST['latitude'];
$item_long = $_POST['longitude'];
$image = $_POST['image'];
//$images = $_POST['images'];
//$base64Images = json_decode($_POST['images']);



$sqlinsert = "INSERT INTO `tbl_items`(`item_owner`,`item_name`, `item_desc`, `item_value`, `item_state`,`item_local`,`item_lat`, `item_long`) VALUES ('$user_id','$item_name','$item_desc','$item_value','$item_state','$item_local','$item_lat','$item_long')";

if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	//$insertedCatchId = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);
	$decoded_string = base64_decode($image);
	$path = '../images/items/'.$filename.'.png';
	file_put_contents($path, $decoded_string);

	// Process each image
	/*foreach ($base64Images as $base64Image) {
		// Decode the base64 image
		$decodedImage = base64_decode($base64Image);
		
		// Generate a unique filename for the image
		$filename = $user_id . '_' . $item_id . '_' . ($index);
		
		// Save the image to the server
		$path = '../assets/catches/' . $filename . 'png';

		file_put_contents($path, $decodedImage);
		
		// Insert image data into the database
		$sqlinsertImage = "INSERT INTO `tbl_catch_images`(`catch_id`, `image_path`) VALUES ('$insertedCatchId', '$filename')";
		$conn->query($sqlinsertImage);
	  }*/

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