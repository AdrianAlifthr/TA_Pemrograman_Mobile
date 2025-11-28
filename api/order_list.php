<?php
    error_reporting(E_ALL);
    ini_set('display_errors', 1);

    header("Content-Type: application/json");
    header("Access-Control-Allow-Origin: *");

    include "connection-pdo.php";

    $sql = "
    SELECT 
        orders.order_id,
        SUBSTRING(orders.table_id, 3) AS table_number,
        orders.order_status,

        GROUP_CONCAT(
            CONCAT(menu_items.menu_name, ' x', order_items.quantity)
            SEPARATOR ', '
        ) AS menu_list

    FROM orders
    JOIN order_items 
        ON orders.order_id = order_items.order_id
    JOIN menu_items 
        ON order_items.menu_id = menu_items.menu_id

    WHERE orders.order_status IN ('WAITING', 'COOKING', 'READY', 'SERVED')

    GROUP BY orders.order_id
    ORDER BY orders.order_created_date DESC
    ";

    try {
        $stmt = $conn->prepare($sql);
        $stmt->execute();
        $data = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            "success" => true,
            "orders" => $data
        ]);

    } catch (PDOException $e) {
        echo json_encode([
            "success" => false,
            "error" => $e->getMessage()
        ]);
    }
?>
