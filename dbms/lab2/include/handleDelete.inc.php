<?php
require_once "../functions/display_alert.php";

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $roll_no = $_POST["roll_no"];

    try {
        require_once "dbh.inc.php";

        // creating query for delete
        $query = "DELETE FROM students WHERE Roll_number=:roll_no;";

        $stmt = $pdo->prepare($query);
        $stmt->bindParam(":roll_no", $roll_no);

        $stmt->execute();

        // ending the query by freeing variables
        $pdo = null;
        $stmt = null;

        // pop up upon submission
        display_alert("Record successfully deleted. Press enter to continue.", "../index.php");


        die();
    } catch (PDOException $e) {
        die("Query Failed: " . $e->getMessage());
    }
} else {
    header("Location: ../index.php");
}
