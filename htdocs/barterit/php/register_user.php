<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

//if (!isset($_POST)) {
if (!isset($_POST['name']) || !isset($_POST['email']) || !isset($_POST['password'])){
    $response = array('status' => 'failed1', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$name = $_POST["name"];
$email = $_POST["email"];
$password = sha1($_POST["password"]);
//$otp = rand(10000,99999);
//$na = "na";

// Sanitize the input values
/*
$user_email = filter_var($email, FILTER_SANITIZE_EMAIL);
$user_name = filter_var($name, FILTER_SANITIZE_FULL_SPECIAL_CHARS);
$user_password = password_hash($password, PASSWORD_DEFAULT);
*/

$sqlinsert = "INSERT INTO tbl_users (user_email, user_name , user_password) VALUES('$email','$name','$password')";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendEmail($email);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed2', 'data' => $conn->error);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
function sendEmail($email){
    //send email function here
}

?>