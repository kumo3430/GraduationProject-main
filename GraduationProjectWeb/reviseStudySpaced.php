<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

// 取得用戶名和密碼
// $userName = $data['userName'];
$uid = $_SESSION['uid'];
// $uuid = $data['uuid'];
$category_id = 1;
$todoTitle = $data['title'];
$todoIntroduction = $data['description'];
// $startDateTime = $data['nextReviewDate'];
$reminderTime = $data['nextReviewTime'];

$todo_id = $data['id'];
$repetition1Status = $data['repetition1Status'];
$repetition2Status = $data['repetition2Status'];
$repetition3Status = $data['repetition3Status'];
$repetition4Status = $data['repetition4Status'];

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

$TodoSql = "UPDATE Todo 
SET `todoTitle` = '$todoTitle',`todoIntroduction` = '$todoIntroduction',`reminderTime` = '$reminderTime'
WHERE `id` = '$todo_id' ;";


$StudySpacedSql = "UPDATE StudySpacedRepetition 
SET `repetition1Status` = '$repetition1Status', `repetition2Status` = '$repetition2Status', `repetition3Status` = '$repetition3Status', `repetition4Status` = '$repetition4Status'
WHERE `todo_id` = '$todo_id' ;";
if ($conn->query($TodoSql) === TRUE) {
    if ($conn->query($StudySpacedSql) === TRUE) {
        $message = "User revise Todo successfully";
    } else {
        $message = 'revise StudySpacedSql - Error: ' . $sql . '<br>' . $conn->error;
        $conn->error;
    }
} else {
    $message = $message . 'revise TodoSql - Error: ' . $sql . '<br>' . $conn->error;
    $conn->error;
}

$userData = array(
    'userId' => $uid,
    'category_id' => $category_id,
    'todoTitle' => $todoTitle,
    'todoIntroduction' => $todoIntroduction,
    'reminderTime' => $reminderTime,
    'todo_id' => $todo_id,
    'repetition1Status' => $repetition1Status,
    'repetition2Status' => $repetition2Status,
    'repetition3Status' => $repetition3Status,
    'repetition4Status' => $repetition4Status,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>