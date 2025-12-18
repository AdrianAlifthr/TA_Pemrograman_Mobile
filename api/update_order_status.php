<?php
    include "connection-pdo.php";

    $order_id = $_POST['order_id'];
    $status = $_POST['status'];

    if(!$order_id || !$status){
        echo json_encode([
            "success"=>false,
            "message"=>"Parameter tidak lengkap"
        ]);
        exit;
    }

    $query = "UPDATE orders SET order_status=? WHERE order_id=?";
    $stmt = $conn->prepare($query);
    $stmt->execute([$status, $order_id]);

    if($stmt->execute()){
        echo json_encode([
            "success"=>true,
            "message"=>"Order updated"
        ]);
    }else{
        echo json_encode([
            "success"=>false,
            "message"=>"Gagal update order"
        ]);
    }
?>
