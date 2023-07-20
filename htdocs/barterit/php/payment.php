<?php
error_reporting(0);

include('config.php');

$email = $_GET['email']; //email
$name = $_GET['name']; 
$userid = $_GET['userid'];
$amount = $_GET['amount']; 
$sellerid = $_GET['sellerid'];


$api_key = 'f9cbf155-a717-4840-acd7-4e594db1e0cf';
$collection_id = 'gy9pauny';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'name' => $name,
          'amount' => ($amount) * 100, // RM20
      'description' => 'Payment for order by '.$name,
          'callback_url' => SERVER_IP . "/barterit/return_url",
          'redirect_url' => SERVER_IP . "/barterit/php/payment_update.php?sellerid=$sellerid&userid=$userid&email=$email&name=$name&amount=$amount" 
);

$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);
header("Location: {$bill['url']}");
?>