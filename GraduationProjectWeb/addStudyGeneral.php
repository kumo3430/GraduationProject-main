<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

// 取得用戶名和密碼
// $userName = $data['userName'];
$uid = $_SESSION['uid'];
// $uuid = $data['uuid'];
$category_id = 0;
$todoTitle = $data['todoTitle'];
$todoIntroduction = $data['todoIntroduction'];


if ( $data['label'] == "") {
    $todoLabel = "notSet";
} else {
    $todoLabel= $data['label'];
}
if ( $data['todoStatus'] == false) {
    $todoStatus = 0;
} else {
    $todoStatus= 1;
}

$startDateTime = $data['startDateTime'];
$reminderTime = $data['reminderTime'];
$dueDateTime = $data['dueDateTime'];
$todoNote = $data['todoNote'];
$todo_id = 0;

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

$TodoSELSql = "SELECT * FROM `Todo` WHERE `uid` = '$uid' && `category_id` = '$category_id' && `todoTitle` = '$todoTitle' && `todoIntroduction` = '$todoIntroduction' && `label` = '$todoLabel'&& `todoNote` = '$todoNote';";

$result = $conn->query($TodoSELSql);
if ($result->num_rows == 0) {

    $TodoSql = "INSERT INTO `Todo` (`uid`, `category_id`, `todoTitle`, `todoIntroduction`, `label`, `startDateTime`, `reminderTime`, `todoStatus`, `dueDateTime`, `todoNote`) VALUES ('$uid', '$category_id','$todoTitle','$todoIntroduction','$todoLabel','$startDateTime','$reminderTime','$todoStatus','$dueDateTime','$todoNote')";

    if ($conn->query($TodoSql) === TRUE) {
        $message = "User New Todo category_id = 0 successfully" . '<br>';

        // 如果成功新增Todo 就查詢此次建立的Todo table 的 id
        $TodoIdSql = "SELECT * FROM `Todo` WHERE `uid` = '$uid' && `category_id` = '$category_id' && `todoTitle` = '$todoTitle' && `todoIntroduction` = '$todoIntroduction' && `label` = '$todoLabel' && `todoNote` = '$todoNote';";

        $result = $conn->query($TodoIdSql);
        if ($result->num_rows > 0) {
            // 如果成功找到就把它存入 StudySpacedRepetition table 的 todo_id
            // 並且在 StudySpacedRepetition table 新增一筆資料
            while ($row = $result->fetch_assoc()) {
                $todo_id = $row['id'];
                // echo "todo_id : " . $todo_id . '<br>';
                $SpacedSql = "INSERT INTO `StudyGeneral` (`todo_id`, `category_id`) VALUES ('$todo_id', '$category_id')";

                if ($conn->query($SpacedSql) === TRUE) {
                    $message = "User New StudyGeneral successfully";
                } else {
                    $message = 'New StudyGeneral - Error: ' . $sql . '<br>' . $conn->error;
                }
            }
        } else {
            $message = "no such StudyGeneralTodo" . '<br>';
        }


    } else {
        $message = 'New StudyGeneral Todo - Error: ' . $sql . '<br>' . $conn->error;
        $conn->error;
    }

} else {
    $message = "The Todo is repeated";
}

$userData = array(
    'todo_id' => $todo_id,
    'userId' => $uid,
    'category_id' => $category_id,
    'label' => $todoLabel,
    'todoTitle' => $todoTitle,
    'todoIntroduction' => $todoIntroduction,
    'startDateTime' => $startDateTime,
    'todoStatus' => $todoStatus,
    'dueDateTime' => $dueDateTime,
    'reminderTime' => $reminderTime,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>