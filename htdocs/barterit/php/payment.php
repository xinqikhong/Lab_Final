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
          'callback_url' => 'http://10.19.93.145/barterit/php/payment_success.php?email=$email&name=$name&amount=$amount',
          //'redirect_url' => 'http://10.19.93.145/barterit/php/payment_success.php?email=$email&name=$name&amount=$amount' 
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
/*if (isset($bill['url'])) {
    // Payment details received successfully, show a success message
    echo "<h2>Payment Successful</h2>";
    echo "<p>Name: $name</p>";
    echo "<p>Email: $email</p>";
    echo "<p>Amount Paid: RM $amount</p>";
    
    // Provide a "Proceed" button for the user to click and redirect to payment_success.php
    echo "<button onclick=\"redirectToPaymentSuccess()\">Proceed</button>";
    
    // JavaScript function to redirect to payment_success.php after clicking the button
    echo "<script>
    function redirectToPaymentSuccess() {
      window.location.href = 'http://localhost/barterit/php/payment_success.php?email=$email&name=$name&amount=$amount';
    }
    </script>";
} else {
    // Payment details not received, show an error message or handle the error accordingly
    echo "<h2>Payment Failed</h2>";
    // Handle the error case here
}*/
?>