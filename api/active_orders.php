<?php
    header('Content-Type: application/json');
    header("Access-Control-Allow-Origin: *");

    include "connection-pdo.php";

    $sql = "
        SELECT COUNT(*) AS active_orders
        FROM orders
        WHERE ORDER_STATUS IN ('waiting', 'cooking')
    ";

    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    echo json_encode([
        "success" => true,
        "active_orders" => $result['active_orders']
    ]);
?>