<?php
    header("Content-Type: application/json");
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Allow-Headers: Content-Type");

    include "connection-pdo.php";

    $table_id = $_POST['table_id'] ?? null;
    $status   = $_POST['status'] ?? null;

    if (!$table_id || !$status) {
        echo json_encode([
            "success" => false, 
            "message" => "Missing table_id or status",
            "received" => $_POST
        ]);
        exit;
    }

    try {
        $sql = "UPDATE tables SET status = :status WHERE table_id = :table_id";
        $stmt = $conn->prepare($sql);
        $stmt->execute([
            ":status" => $status,
            ":table_id" => $table_id
        ]);

        echo json_encode(["success" => true, "message" => "Status updated"]);
    } 
    catch (Exception $e) {
        echo json_encode(["success" => false, "error" => $e->getMessage()]);
    }
?>

