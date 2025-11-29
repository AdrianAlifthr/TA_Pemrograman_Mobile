<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
include "connection-pdo.php";

$category = $_GET["category"] ?? "";
$search   = $_GET["search"] ?? "";

$sql = "
SELECT 
    menu_id,
    menu_name,
    category_id,
    price,
    available,
    path
FROM menu_categories
WHERE 1=1
";

$params = [];

if (!empty($category)) {
    $sql .= " AND category_id = :category ";
    $params[':category'] = $category;
}

if (!empty($search)) {
    $sql .= " AND LOWER(menu_name) LIKE :search ";
    $params[':search'] = "%" . strtolower($search) . "%";
}

$sql .= " ORDER BY menu_name ASC";

$stmt = $conn->prepare($sql);
$stmt->execute($params);

$data = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode([
    "success" => true,
    "data" => $data
]);
