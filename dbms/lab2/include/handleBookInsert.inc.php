<?php
function display_alert($message = "Invalid message", $location = "index.php")
{
    echo '<script type="text/javascript">
                alert("' . $message . '");
                window.location.href = "' . $location . '";
                </script>';
}

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $book = $_POST["book"];
    $bid = $_POST["bid"];

    try {
        require_once "dbh.inc.php";

        // creating query for select
        $query = "SELECT * FROM books WHERE book_id=:bid;";

        //execute query
        $stmt = $pdo->prepare($query);
        $stmt->bindParam(":bid", $bid);
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        echo var_dump($result);
        $stmt = null;

        if ($result) {
            $pdo = null; // close the connection
            display_alert("Book id already exists. Press enter to continue.", "../index.php");
        }

        $query = "INSERT INTO books(book_id, book_name) VALUES (:bid,:book);";

        $stmt = $pdo->prepare($query);
        $stmt->bindParam(":bid", $bid);
        $stmt->bindParam(":book", $book);

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
