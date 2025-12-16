<?php
    header("Content-Type: application/json");
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Headers: Content-Type");

    include "connection-pdo.php";

    $task_number = $_POST['task_number'] ?? '';
    $status      = $_POST['status'] ?? '';

    if (!$task_number || !$status) {
        echo json_encode([
            "success" => false,
            "message" => "Invalid parameter"
        ]);
        exit;
    }

    if (!in_array($status, ['cooking','ready'])) {
        echo json_encode([
            "success" => false,
            "message" => "Invalid status"
        ]);
        exit;
    }

    try {
        $conn->beginTransaction();
        if ($status === 'cooking') {

            $sql = "
                UPDATE kitchen_tasks
                SET 
                    kitchen_status = :status,
                    started_at = NOW()
                WHERE task_number = :task
            ";

        } else {

            $sql = "
                UPDATE kitchen_tasks
                SET kitchen_status = :status
                WHERE task_number = :task
            ";
        }

        $stmt = $conn->prepare($sql);

        $stmt->execute([
            ":status" => $status,
            ":task"   => $task_number
        ]);

        if ($stmt->rowCount() === 0) {
            throw new Exception("Task not found");
        }
        $sqlOrder = "
            UPDATE orders o
            JOIN kitchen_tasks kt ON kt.order_id = o.order_id
            SET o.order_status = :status
            WHERE kt.task_number = :task
        ";

        $stmtOrder = $conn->prepare($sqlOrder);

        $stmtOrder->execute([
            ":status" => $status,
            ":task"   => $task_number
        ]);

        $conn->commit();

        echo json_encode([
            "success" => true,
            "task_number" => $task_number,
            "new_status" => $status,
            "updated_orders" => $stmtOrder->rowCount()
        ]);

    } catch (Exception $e) {

        if ($conn->inTransaction()) {
            $conn->rollBack();
        }

        echo json_encode([
            "success" => false,
            "error" => $e->getMessage()
        ]);
    }
?>