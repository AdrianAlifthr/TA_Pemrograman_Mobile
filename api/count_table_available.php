<?php
    header('Content-Type: application/json');
    header("Access-Control-Allow-Origin: *");

    include "connection-pdo.php";

    // Hitung total meja
    $total = $conn->query("SELECT COUNT(*) FROM tables")->fetchColumn();

    // Hitung meja terisi (BOOKED)
    $booked = $conn->query("SELECT COUNT(*) FROM tables WHERE status = 'BOOKED'")->fetchColumn();

    echo json_encode([
        "success" => true,
        "total" => $total,
        "booked" => $booked
    ]);
?>
