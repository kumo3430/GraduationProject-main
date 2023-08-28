<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

// 取得用戶名和密碼
// $userName = $data['userName'];
// $uid = $_SESSION['uid'];
$uid = $data['uid'];
$_SESSION['uid'] = $uid ;
$category_id = 0;

$TodoTitle = array();
$TodoIntroduction = array();
$TodoLabel = array();
$StartDateTime = array();
$frequency = array();
$ReminderTime = array();
$todo_id = array();
$todoStatus = array();
$dueDateTime = array();
$todoNote = array();


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

$TodoSELSql = "SELECT * FROM Todo T RIGHT JOIN StudyGeneral SG ON T.id = SG.todo_id WHERE T.uid = '$uid' && T.category_id = '0';";

$result = $conn->query($TodoSELSql);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $TodoTitle[] = $row['todoTitle'];
        $TodoIntroduction[] = $row['todoIntroduction'];
        $TodoLabel[] = $row['label'];
        $StartDateTime[] = $row['startDateTime'];
        $frequency[] = $row['frequency'];
        $ReminderTime[] = $row['reminderTime'];
        $todo_id[] = $row['todo_id'];
        $todoStatus[] = $row['todoStatus'];
        $dueDateTime[] = $row['dueDateTime'];
        $todoNote[] = $row['todoNote'];
    }
} else {
    $message = "no such Todo";
}
$userData = array(
    'userId' => $uid,
    'category_id' => $category_id,
    'todoTitle' => $TodoTitle,
    'todoIntroduction' => $TodoIntroduction,
    'todoLabel' => $TodoLabel,
    'startDateTime' => $StartDateTime,
    'frequency' => $frequency,
    'reminderTime' => $ReminderTime,
    'todo_id' => $todo_id,
    'todoStatus' => $todoStatus,
    'dueDateTime' => $dueDateTime,
    'todoNote' => $todoNote,
    'message' => ""
);
echo json_encode($userData);
$conn->close();
?>