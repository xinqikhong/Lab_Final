<?php
// Retrieve payment details from query parameters
$email = $_GET['email'];
$name = $_GET['name'];
$amount = $_GET['amount'];

// Format the amount to display with 2 decimal places
$formattedAmount = number_format($amount, 2);


// Display the payment information to the user
echo "<h2>Payment Successful</h2>";
echo "<p>Name: $name</p>";
echo "<p>Email: $email</p>";
echo "<p>Amount Paid: RM $formattedAmount</p>";

// Provide a "Success" button for the user to click
echo "<button onclick=\"redirectToPaymentUpdate()\">Success</button>";

// JavaScript function to redirect to payment_update.php after clicking the button
echo "<script>
function redirectToPaymentUpdate() {
  window.location.href = 'payment_update.php?email=$email&name=$name&amount=$amount';
}
</script>";
?>
