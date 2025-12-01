<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection-pdo.php";

    try {
        $sql = "
            SELECT TABLE_ID, STATUS
            FROM `tables`
            ORDER BY CAST(SUBSTRING(TABLE_ID, 3) AS UNSIGNED)
        ";
        $stmt = $conn->prepare($sql);
        $stmt->execute();
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        function iconForStatus($status) {
            $s = strtoupper($status);
            if ($s === 'BOOKED') return 'meja-booked.png';
            if ($s === 'CLEANING') return 'meja-cleaning.png';
            if ($s === 'AVAILABLE') return 'meja-available.png';
            return 'meja_hijau.png';
        }

        $data = [];
        foreach ($rows as $r) {
            $data[] = [
                'table_id' => $r['TABLE_ID'],
                'status'   => $r['STATUS'],
                'icon'     => iconForStatus($r['STATUS'])
            ];
        }

        echo json_encode([
            'success' => true,
            'tables' => $data
        ]);

    } catch (Exception $e) {
        echo json_encode([
            'success' => false,
            'error' => $e->getMessage()
        ]);
    }
?>
