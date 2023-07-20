<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$itemid = $_POST['item_id'];
$cartqty = $_POST['cart_qty'];
$cartprice = $_POST['cart_price'];
$userid = $_POST['userid'];
$sellerid = $_POST['sellerid'];

$checkitemid = "SELECT * FROM `tbl_carts` WHERE `user_id` = '$userid' AND  `item_id` = '$itemid'";
$resultqty = $conn->query($checkitemid);
$numresult = $resultqty->num_rows;
if ($numresult > 0) {
	$sql = "UPDATE `tbl_carts` SET `cart_qty`= (cart_qty + $cartqty),`cart_price`= (cart_price+$cartprice) WHERE `user_id` = '$userid' AND  `item_id` = '$itemid'";
}else{
	$sql = "INSERT INTO `tbl_carts`(`item_id`, `cart_qty`, `cart_price`, `user_id`, `seller_id`) VALUES ('$itemid','$cartqty','$cartprice','$userid','$sellerid')";
}

if ($conn->query($sql) === TRUE) {
	// Get the updated cart quantity for the user
    $updatedCartQty = 0;
    $getCartQtyQuery = "SELECT SUM(cart_qty) as cartqty FROM `tbl_carts` WHERE `user_id` = '$userid'";
    $result = $conn->query($getCartQtyQuery);
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $updatedCartQty = (int)$row['cartqty'];
    }
	
	$response = array('status' => 'success', 'data' => $sql, 'cartqty' => $updatedCartQty);
	sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => $sql);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>