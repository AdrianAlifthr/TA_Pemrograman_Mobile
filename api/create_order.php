<?php
    header("Content-Type: application/json");
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Headers: Content-Type");

    include "connection-pdo.php";

    $raw   = file_get_contents("php://input");
    $data  = json_decode($raw, true) ?? [];

    $table_id       = $data['table_id']        ?? ($_POST['table_id'] ?? '');
    $items           = $data['items']          ?? ($_POST['items'] ?? []);
    $payment_method  = $data['payment_method'] ?? ($_POST['payment_method'] ?? 'CASH');

    if (is_string($items)) {
        $items = json_decode($items, true);
    }
    if (!$table_id || !is_array($items) || count($items) == 0) {
        echo json_encode([
            "success" => false,
            "message" => "Missing table_id or items"
        ]);
        exit;
    }
    preg_match('/(\d+)/', $table_id, $match);
    $tableNum = $match[1] ?? null;

    if (!$tableNum) {
        echo json_encode([
            "success" => false,
            "message" => "Invalid table id"
        ]);
        exit;
    }

    $table_id = "T_" . $tableNum;

    try {

        $conn->beginTransaction();
        $menuIds = array_map(fn ($i) => $i['menu_id'], $items);
        $in = implode(',', array_fill(0, count($menuIds), '?'));

        $sql = "SELECT MENU_ID, PRICE FROM menu_categories WHERE MENU_ID IN ($in)";
        $stmt = $conn->prepare($sql);
        $stmt->execute($menuIds);

        $priceMap = $stmt->fetchAll(PDO::FETCH_KEY_PAIR);

        if (!$priceMap) {
            throw new Exception("Menu not found");
        }
        $total = 0;

        foreach ($items as $row) {
            $mid = $row['menu_id'];
            $qty = intval($row['quantity']);

            $price = $priceMap[$mid] ?? 0;

            if (!is_numeric($price)) {
                preg_match_all('/\d+/', $price, $m);
                $price = intval(implode('', $m[0]));
            }

            $total += ($price * $qty);
        }
        $orderId  = "O_" . uniqid();

        $sqlOrder = "
            INSERT INTO orders
            (order_id, table_id, order_status, order_total_amount, order_created_date)
            VALUES (:oid, :tid, 'waiting', :total, NOW())
        ";

        $stmtOrder = $conn->prepare($sqlOrder);
        $stmtOrder->execute([
            ':oid'     => $orderId,
            ':tid'     => $table_id,
            ':total'   => $total,
        ]);
        $sqlItem = "
            INSERT INTO order_items
            (order_items_id, order_id, menu_item_id, quantity, unit_price, status)
            VALUES (:oiid,:oid,:mid,:qty,:price,'waiting')
        ";

        $stmtItem = $conn->prepare($sqlItem);
        $counter = 1;

        foreach ($items as $row) {

            $mid = $row['menu_id'];
            $qty = intval($row['quantity']);

            $unit = $priceMap[$mid];

            if (!is_numeric($unit)) {
                preg_match_all('/\d+/', $unit, $m);
                $unit = intval(implode('', $m[0]));
            }
            $oi_id = "OI_{$orderId}_{$counter}";
            $counter++;

            $stmtItem->execute([
                ':oiid' => $oi_id,
                ':oid'  => $orderId,
                ':mid'  => $mid,
                ':qty'  => $qty,
                ':price'=> $unit,
            ]);
        }
        $sqlKitchen = "
            INSERT INTO kitchen_tasks
            (order_id, kitchen_status)
            VALUES (:oid, 'waiting')
        ";

        $stmtKitchen = $conn->prepare($sqlKitchen);
        $stmtKitchen->execute([
            ':oid' => $orderId
        ]);
        $conn->commit();
        echo json_encode([
            "success"   => true,
            "order_id" => $orderId,
            "table"    => $table_id,
            "total"    => $total,
            "items"    => count($items),
            "payment"  => $payment_method,
            "message"  => "Order berhasil dikirim ke kitchen"
        ]);

    } catch (Exception $e) {

        $conn->rollBack();

        echo json_encode([
            "success" => false,
            "message" => "Gagal membuat order",
            "error"   => $e->getMessage()
        ]);
    }
?>
