<?php
function display_alert($message = "Invalid message", $location = "index.php")
{
    echo '<script type="text/javascript">
                alert("' . $message . '");
                window.location.href = "' . $location . '";
                </script>';
}

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $firstName = $_POST["firstName"];
    $roll_no = $_POST["rollNo"];

    try {
        require_once "dbh.inc.php";

        // creating query for insert
        $query = "SELECT * FROM students where Roll_number=:roll;";

        $stmt = $pdo->prepare($query);

        $stmt->bindParam(":roll", $roll_no);

        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        $stmt = null;

        if ($result) {
            $pdo = null; // close the connection
            display_alert("Roll Number already exists. Press enter to continue.", "../index.php");
        }

        $query = "INSERT INTO students(Roll_number, first_name) VALUES (:roll,:firstName);";

        $stmt = $pdo->prepare($query);
        $stmt->bindParam(":roll", $roll_no);
        $stmt->bindParam(":firstName", $firstName);

        $stmt->execute();

        // ending the query by freeing variables
        $pdo = null;
        $stmt = null;

        // pop up upon submission
        display_alert("Record successfully inserted. Press enter to continue.", "../index.php");

        die();
    } catch (PDOException $e) {
        die("Query Failed: " . $e->getMessage());
    }
} else {
    header("Location: ../index.php");
}
