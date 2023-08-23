<?php
session_start();

// $input_data = file_get_contents("php://input");
// $data = json_decode($input_data, true);

// $uid = $_SESSION['uid'];
$uid = 30;
$ticker_id = array();
$name = array();
$deadline = array();
$exchange = array();
$message = "";


$servername = "localhost";
$user = "kumo";
$pass = "coco3430";
$dbname = "spaced";

$conn = new mysqli($servername, $user, $pass, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// $sql = "SELECT * FROM `tickers` INNER JOIN `voucher` ON tickers.voucher_id = voucher.id WHERE tickers.userID = '$uid';";
$sql = "SELECT tickers.id,tickers.exchange_time,voucher.name,voucher.deadline FROM `tickers` INNER JOIN `voucher` ON tickers.voucher_id = voucher.id WHERE tickers.userID = '30';";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $ticker_id[] = $row['id'];
        $name[] = $row['name'];
        $deadline[] = $row['deadline'];
        $exchange[] = $row['exchange_time'];
        // echo $ticker_id;
        // echo $name;
        // echo $deadline;
        // echo $exchange;
    }
} else {
    $message = "no such Todo";
}

$userData = array(
    'ticker_id' => $ticker_id,
    'userId' => $uid,
    'name' => $name,
    'deadline' => $deadline,
    'exchange' => $exchange,
    'message' => $message
);
echo json_encode($userData);

?>