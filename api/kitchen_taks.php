<?php
    header("Content-Type: application/json");
    header("Access-Control-Allow-Origin: *");

    include "connection-pdo.php";

    try {

        $sql = "
            SELECT 
                kt.task_number,
                kt.order_id,
                kt.kitchen_status,
                kt.started_at,

                o.table_id,
                o.order_created_date,

                GROUP_CONCAT(
                    CONCAT(mc.menu_name, ' x', oi.quantity)
                    SEPARATOR ', '
                ) AS items

            FROM kitchen_tasks kt

            JOIN orders o 
                ON kt.order_id = o.order_id

            JOIN order_items oi
                ON o.order_id = oi.order_id

            JOIN menu_categories mc
                ON oi.menu_item_id = mc.menu_id

            GROUP BY kt.task_number

            ORDER BY o.order_created_date ASC
        ";

        $stmt = $conn->prepare($sql);
        $stmt->execute();

        $data = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            "success" => true,
            "data" => $data
        ]);

    } catch (Exception $e) {

        echo json_encode([
            "success" => false,
            "message" => "Gagal mengambil data kitchen tasks",
            "error"   => $e->getMessage()
        ]);

    }
?>
