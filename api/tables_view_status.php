<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

include "connection-pdo.php";

$sql = "
    SELECT 
        TABLE_ID,
        STATUS
    FROM tables
    ORDER BY CAST(SUBSTRING(TABLE_ID, 3) AS UNSIGNED)
";

$stmt = $conn->prepare($sql);
$stmt->execute();

$data = [];

while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

    // Ambil nomor meja dari T_1 -> 01
    $number = str_pad(str_replace("T_", "", $row['TABLE_ID']), 2, "0", STR_PAD_LEFT);

    // Normalisasi status
    $statusRaw = strtoupper($row['STATUS']);

    switch ($statusRaw) {
        case "AVAILABLE":
            $status = "available";
            break;
        case "BOOKED":
            $status = "booked";
            break;
        case "CLEANING":
            $status = "cleaning";
            break;
        default:
            $status = "ready";
    }

    $data[] = [
        "number"   => $number,
        "capacity" => "4 Kursi",
        "status"   => $status
    ];
}

echo json_encode([
    "success" => true,
    "data" => $data
]);
