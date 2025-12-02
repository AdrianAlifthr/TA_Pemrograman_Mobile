<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

include "connection-pdo.php";

try {

    $sql = "
    SELECT 
        kt.TASK_NUMBER,
        kt.ORDER_ID,
        kt.STATION,
        kt.KITCHEN_STATUS,
        kt.ESTIMATED_MIN,
        kt.STARTED_AT,

        o.TABLE_ID,
        o.ORDER_CREATED_DATE,

        GROUP_CONCAT(
            CONCAT(mc.MENU_NAME, ' x', oi.quantity)
            SEPARATOR ', '
        ) AS ITEMS

    FROM kitchen_tasks kt

    JOIN orders o 
        ON kt.ORDER_ID = o.ORDER_ID

    JOIN order_items oi
        ON o.ORDER_ID = oi.order_id

    JOIN menu_categories mc
        ON oi.menu_item_id = mc.MENU_ID

    GROUP BY kt.TASK_NUMBER
    ORDER BY o.ORDER_CREATED_DATE ASC
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
        "error" => $e->getMessage()
    ]);
}
