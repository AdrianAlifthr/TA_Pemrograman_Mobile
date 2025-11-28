<?php
    header('Content-Type: application/json');
    header("Access-Control-Allow-Origin: *");

    include "connection-pdo.php";

    $total = $conn->query("SELECT COUNT(*) FROM tables")->fetchColumn();

    $booked = $conn->query("SELECT COUNT(*) FROM tables WHERE status = 'BOOKED'")->fetchColumn();

    echo json_encode([
        "success" => true,
        "total" => $total,
        "booked" => $booked
    ]);
?>
