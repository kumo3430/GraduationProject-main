<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

// 取得用戶名和密碼
// $userName = $data['userName'];
$uid = $_SESSION['uid'];

$today = date("Y/n/j");     

$servername = "localhost"; // 資料庫伺服器名稱
$user = "kumo"; // 資料庫使用者名稱
$pass = "coco3430"; // 資料庫使用者密碼
$dbname = "spaced"; // 資料庫名稱

// 建立與 MySQL 資料庫的連接
$conn = new mysqli($servername, $user, $pass, $dbname);
// 檢查連接是否成功
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

function insertRecurringInstance($conn, $todo_id, $startDateTime, $RecurringEndDate) {
    $InstanceSql = "INSERT INTO `RecurringInstance` (`todo_id`, `RecurringStartDate`, `RecurringEndDate`) VALUES ('$todo_id', '$startDateTime', '$RecurringEndDate');";

    if($conn->query($InstanceSql) === TRUE) {
        $message = "User New first RecurringInstance successfully";
    } else {
        $message = "New first RecurringInstance successfully - Error: " . $InstanceSql . '<br>' . $conn->error; 
        if ($conn->connect_error) {
            $message =  die("Connection failed: " . $conn->connect_error);
        }
        
    }
    return $message;
}

$TodoSELSql = "SELECT `Todo`.frequency, `RecurringInstance`.RecurringEndDate, `Todo`.id FROM `Todo`,`RecurringInstance` WHERE `Todo`.dueDateTime > '$today'  AND `Todo`.id = `RecurringInstance`.todo_id AND `RecurringEndDate` = '$today' AND `RecurringInstance`.isOver = 0 ;";

$update = "UPDATE `RecurringInstance` SET `isOver` = '1'  WHERE `RecurringEndDate` = '$today' ";
$result = $conn->query($TodoSELSql);
if ($result->num_rows > 0) {
    
    while ($row = $result->fetch_assoc()) {
        $RecurringEndDate_data = $row['RecurringEndDate'];
        $frequency = $row['frequency'];
        $todo_id = $row['id'];
        $RecurringStartDate_new = date('Y-m-d', strtotime("$RecurringEndDate_data +1 day"));
        $conn->query($update); // 執行更新操作;
        if ($frequency == 1) {
            // 每天重複
            $RecurringEndDate_new = $RecurringStartDate_new;
            $message = insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
            $conn->query($update); // 執行更新操作
        } else if ($frequency == 2) {
            // 每週重複
            $RecurringEndDate_new = date('Y-m-d', strtotime("$RecurringEndDate_data +6 day"));
            $message = insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
            $conn->query($update); // 執行更新操作
        } else if ($frequency == 3) {
            // 每月重複
            $RecurringEndDate_new = date('Y-m-d', strtotime("$RecurringEndDate_data +1 month"));
            $message = insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
            $conn->query($update); // 執行更新操作
        }
    }

} else {
    $message = "今日沒有要新增的";
}


$userData = array(
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>