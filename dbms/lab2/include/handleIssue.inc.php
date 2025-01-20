<?php
function display_alert($message = "Invalid message", $location = "index.php")
{
    echo '<script type="text/javascript">
                alert("' . $message . '");
                window.location.href = "' . $location . '";
                </script>';
}

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $bookID = $_POST["bookID"];
    $roll_no = $_POST["rollNo"];

    try {
        require_once "dbh.inc.php";

        // check if book is issued or not
        $query = "SELECT book_id FROM has_issued WHERE book_id = :book_id AND return_date IS NULL;";

        $stmt = $pdo->prepare($query);

        $stmt->bindParam(":book_id", $bookID);

        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        $stmt = null;

        if ($result) {
            $pdo = null; // close the connection
            display_alert("Book already issued. Press enter to continue.", "../index.php");
        }

        // issue book
        $query = "INSERT INTO `has_issued`(`book_id`, `Roll_number`) VALUES (:book_id,:roll);";

        $stmt = $pdo->prepare($query);
        $stmt->bindParam(":roll", $roll_no);
        $stmt->bindParam(":book_id", $bookID);

        $stmt->execute();

        // ending the query by freeing variables
        $pdo = null;
        $stmt = null;

        // pop up upon submission
        display_alert("Book successfully issued. Press enter to continue.", "../index.php");

        die();
    } catch (PDOException $e) {
        die("Query Failed: " . $e->getMessage());
    }
} else {
    header("Location: ../index.php");
}
