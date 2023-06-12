<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['item_owner'])){
	$userid = $_POST['item_owner'];	
	$sqlloaditems = "SELECT * FROM `tbl_items` WHERE item_owner = '$userid'";
}if (isset($_POST['search'])){
	$search = $_POST['search'];
	$sqlloaditems = "SELECT * FROM `tbl_items` WHERE item_name LIKE '%$search%'";
}else{
	$sqlloaditems = "SELECT * FROM `tbl_items`";
}

$result = $conn->query($sqlloaditems);
if ($result->num_rows > 0) {
    $items["items"] = array();
	while ($row = $result->fetch_assoc()) {
        $itemlist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['item_owner'] = $row['item_owner'];
        $itemlist['item_name'] = $row['item_name'];
        $itemlist['item_value'] = $row['item_value'];
        $itemlist['item_state'] = $row['item_state'];
        $itemlist['item_local'] = $row['item_local'];
        array_push($items["items"],$itemlist);
    }
    $response = array('status' => 'success', 'data' => $items);
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