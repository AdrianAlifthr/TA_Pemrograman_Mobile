<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "connection-pdo.php";

$username = $_GET['username'] ?? '';
$password = $_GET['password'] ?? '';

$sql = "SELECT user_id, username, role 
        FROM user_data_login
        WHERE BINARY username = :username 
        AND BINARY password = :password";

$stmt = $conn->prepare($sql);
$stmt->bindParam(":username", $username);
$stmt->bindParam(":password", $password);
$stmt->execute();

$user = $stmt->fetch(PDO::FETCH_ASSOC);

if ($user) {
    echo json_encode([
        "status" => "success",
        "message" => "Login berhasil",
        "user" => $user
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Username atau password salah"
    ]);
}
?>
