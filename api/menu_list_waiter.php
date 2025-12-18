<?php
    header("Content-Type: application/json");
    header("Access-Control-Allow-Origin: *");
    include "connection-pdo.php";

    $category = $_GET['category'] ?? '';
    $search = $_GET['search'] ?? '';

    $sql = "SELECT MENU_ID as menu_id, MENU_NAME as menu_name, CATEGORY_ID as category_id, PRICE as price, AVAILABLE as available, PATH as path FROM menu_categories WHERE 1=1";
    $params = [];

    if ($category !== '' && strtoupper($category) !== 'ALL') {
        $sql .= " AND CATEGORY_ID = :cat";
        $params[':cat'] = $category;
    }
    if ($search !== '') {
        $sql .= " AND LOWER(MENU_NAME) LIKE :search";
        $params[':search'] = '%'.strtolower($search).'%';
    }

    $sql .= " ORDER BY MENU_NAME ASC";

    try {
        $stmt = $conn->prepare($sql);
        $stmt->execute($params);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // normalize price -> numeric (int)
        foreach ($rows as &$r) {
            // if price already numeric, keep; else strip nondigits
            $p = $r['price'];
            if (!is_numeric($p)) {
                preg_match_all('/\d+/', $p, $m);
                $num = implode('', $m[0]);
                $r['price'] = (int)$num;
            } else {
                $r['price'] = (int)$p;
            }
            // available to 0/1
            $r['available'] = ($r['available'] == 1 || $r['available'] === '1' || strtoupper($r['available']) === 'TRUE') ? 1 : 0;
        }

        echo json_encode(["success" => true, "data" => $rows]);
    } catch (Exception $e) {
        echo json_encode(["success" => false, "error" => $e->getMessage()]);
    }
?>
