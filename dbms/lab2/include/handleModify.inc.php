<?php
require_once "../functions/display_alert.php";
require_once "../functions/console.php";

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $roll_no = $_POST["roll_no"];
    $firstName = $_POST["firstName"];

    try {
        require_once "dbh.inc.php";


        // creating query for select
        $query = "SELECT * FROM students WHERE Roll_number=:roll;";

        $stmt = $pdo->prepare($query);
        $stmt->bindParam(":roll", $roll_no);
        $stmt->execute();

        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $stmt = null;

        // echo var_dump($results[0]["first_name"]);

        // no such student with roll
        if (!$results) {
            $pdo = null;
            display_alert("Student not found", "../index.php");
            die();
        }

        // creating query for update
        $query = "UPDATE students SET First_name=:firstName WHERE Roll_number=:roll;";
        $stmt = $pdo->prepare($query);

        // change to updated values, keep same if empty
        $firstName = (empty($firstName)) ? $results[0]["first_name"] : $firstName;

        $stmt->bindParam(":roll", $roll_no);
        $stmt->bindParam(":firstName", $firstName);

        $stmt->execute();

        // ending the query by freeing variables
        $pdo = null;
        $stmt = null;

        // pop up upon submission
        display_alert("Record successfully updated. Press enter to continue.", "../index.php");

        die();
    } catch (PDOException $e) {
        die("Query Failed: " . $e->getMessage());
    }
} else {
    display_alert("Error");
}
