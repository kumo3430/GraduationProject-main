<?php
    session_start();

    // $input_data = file_get_contents("php://input");
    // $data = json_decode($input_data, true);

    $uid = $_SESSION['uid'];
    $name = array();
    $deadline = array();
    $exchange = array();
    $message = "";


    $servername = "localhost";
    $user = "kumo";
    $pass = "coco3430";
    $dbname = "spaced";

    $conn = new mysqli($servername, $user, $pass, $dbname);
    if($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // $sql = "SELECT id FROM tickers WHERE userId = '$uid' ;";
    $sql = "SELECT * FROM `tickers` INNER JOIN `voucher` ON tickers.voucher_id = voucher.id WHERE tickers.userID = '$uid';";

    $result = $conn->query($sql);
    if($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            // $list[] = $row['id'];
            $name[] = $row['name'];
            $deadline[] = $row['deadline'];
            $exchange[] = $row['exchange'];
        }
    }else {
        $message = "no such Todo";
    }

    $userData = array(
        'userId' => $uid,
        // 'list' => $list,
        'name' => $name,
        'deadline' => $deadline,
        'exchange' => $exchange,
        'message' => $message
    );

?>