<?php
    header("Content-Type: application/json");
    header("Access-Control-Allow-Origin: *");

    include "connection-pdo.php";

    $menu_id   = $_POST["menu_id"] ?? "";
    $available = $_POST["available"] ?? "";

    if (!$menu_id) {
        echo json_encode(["success" => false, "message" => "Menu id required"]);
        exit;
    }

    $sql = "UPDATE menu_categories SET available = :available WHERE menu_id = :menu_id";
    $stmt = $conn->prepare($sql);
    $stmt->execute([
        ":menu_id" => $menu_id,
        ":available" => $available
    ]);

    echo json_encode(["success" => true]);
?>