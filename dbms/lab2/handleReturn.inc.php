<?php
function display_alert($message = "Invalid message", $location = "index.php")
{
    echo '<script type="text/javascript">
                alert("' . $message . '");
                window.location.href = "' . $location . '";
                </script>';
}

if ($_SERVER['REQUEST_METHOD'] == "GET") {
    $roll_no = $_GET["rollNo"];

    try {
        require "include/dbh.inc.php";

        // check if book is issued or not
        $query = "SELECT 
                        h.transaction_id AS tid,
                        h.Roll_number AS roll, 
                        b.book_id AS ID, 
                        b.book_name AS book_name
                    FROM 
                        has_issued h
                    INNER JOIN 
                        books b ON h.book_id = b.book_id
                    WHERE 
                        h.Roll_number = :roll AND 
                        h.return_date IS NULL;";


        $stmt = $pdo->prepare($query);

        $stmt->bindParam(":roll", $roll_no);

        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        $stmt = null;

        // if nothing was found
        if (!$result) {
            $pdo = null; // close the connection
            display_alert("No books issued. Press enter to continue.", "index.php");
            die();
        }

        // ending the query by freeing variables
        $pdo = null;
    } catch (PDOException $e) {
        die("Query Failed: " . $e->getMessage());
    }
} else if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $tid = $_POST["tid"];

    try {
        require "include/dbh.inc.php";

        // check if book is issued or not
        $query = "UPDATE has_issued
                    SET return_date = current_timestamp
                    WHERE transaction_id = :tid;";


        $stmt = $pdo->prepare($query);

        $stmt->bindParam(":tid", $tid);

        $stmt->execute();

        // ending the query by freeing variables
        $stmt = null;
        $pdo = null;

        display_alert("Book returned. Press enter to continue.", "index.php");
        die();
    } catch (PDOException $e) {
        die("Query Failed: " . $e->getMessage());
    }
} else {
    header("Location: index.php");
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Book</title>
    <link rel="stylesheet" href="css/form.css">
</head>

<body>
    <?php
    if (empty($result)) {
        display_alert("No search results found.");
        die();
    } else { ?>
        <div class="sellform">
            <h1 class="sftitle">Issued Books</h1>

            <div class="sfcontainer">

                <?php
                include "forms/returnBookPage.php";
                ?>

            </div>
            <button class="sfsubmit" id="go_back_btn" onclick="window.location.href='index.php'">Go Back</button>
        </div>
    <?php
    }
    ?>
</body>

</html>