<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

include "connection-pdo.php";

$task_number = $_POST['task_number'] ?? '';
$status       = $_POST['status'] ?? '';

if(!$task_number || !$status){
    echo json_encode(["success"=>false,"message"=>"Invalid parameter"]);
    exit;
}

try {

    if($status == 'cooking'){
        $sql = "
            UPDATE kitchen_tasks 
            SET 
                KITCHEN_STATUS = 'cooking',
                STARTED_AT = NOW()
            WHERE TASK_NUMBER = ?
        ";
        $stmt = $conn->prepare($sql);
        $stmt->execute([$task_number]);
    }
    
    
    if($status == 'ready'){
        $sql = "
            UPDATE kitchen_tasks 
            SET 
                KITCHEN_STATUS = 'ready'
            WHERE TASK_NUMBER = ?
        ";
        $stmt = $conn->prepare($sql);
        $stmt->execute([$task_number]);
    }

    echo json_encode(["success"=>true]);

} catch(Exception $e){
    echo json_encode(["success"=>false,"error"=>$e->getMessage()]);
}
